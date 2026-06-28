#!/usr/bin/swift

import AppKit
import Combine
import Network

/// kanata TCP 服务监听端口
let kanataPort: NWEndpoint.Port = 9999

/// kanata 服务器响应消息(仅解码本 daemon 关心的字段)。
/// kanata 协议为 serde externally-tagged 枚举,响应形如
/// `{"LayerNames":{"names":["base","nav","num"]}}`;非本消息类型时字段为 nil 被跳过。
private struct ServerMessage: Decodable {
    struct LayerNamesPayload: Decodable { let names: [String] }
    let LayerNames: LayerNamesPayload?
}

/// 客户端发往 kanata 的消息(serde externally-tagged 枚举的 Swift 对应物)。
/// 用例名直接对齐协议变体名,由编译器自动合成 Encodable,序列化形如
/// `{"ChangeLayer":{"new":"base"}}` 与 `{"RequestLayerNames":{}}`。
private enum ClientMessage: Encodable {
    case ChangeLayer(new: String)
    case RequestLayerNames
}

/// 按 `\n` 分帧的自定义 framer(对应 Rust `BufReader` 的按行读取)。
/// 接管分帧后,应用层收发的都是「一条完整 JSON」:输入侧把 TCP 字节流切成一条条
/// 完整行向上投递,输出侧自动为每条消息追加 `\n` 分隔符。
final class NewlineFramer: NWProtocolFramerImplementation {
    static let definition = NWProtocolFramer.Definition(implementation: NewlineFramer.self)
    static var label: String { "NewlineFramer" }

    init(framer: NWProtocolFramer.Instance) {}
    func wakeup(framer: NWProtocolFramer.Instance) {}
    func cleanup(framer: NWProtocolFramer.Instance) {}
    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult { .ready }
    func stop(framer: NWProtocolFramer.Instance) -> Bool { true }

    /// 逐条切出以 `\n` 结尾的行(含换行符一并投递);行未完整时返回等待更多数据。
    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        while true {
            // 仅窥探一行的长度(含换行),返回 0 表示不在闭包内消费字节
            var lineLength: Int?
            _ = framer.parseInput(minimumIncompleteLength: 1, maximumLength: .max) { buffer, _ in
                lineLength = buffer?.firstIndex(of: UInt8(ascii: "\n")).map { $0 + 1 }
                return 0
            }
            guard let length = lineLength else { return 0 }  // 行未完整,等更多数据
            let message = NWProtocolFramer.Message(definition: NewlineFramer.definition)
            if !framer.deliverInputNoCopy(length: length, message: message, isComplete: true) {
                return 0
            }
        }
    }

    /// 透传应用层消息体,并补一个 `\n` 作为分隔符。
    func handleOutput(
        framer: NWProtocolFramer.Instance,
        message: NWProtocolFramer.Message,
        messageLength: Int,
        isComplete: Bool
    ) {
        try? framer.writeOutputNoCopy(length: messageLength)
        framer.writeOutput(data: Data("\n".utf8))
    }
}

/// kanata 客户端:维护一条常驻 TCP 连接。
final class KanataClient {
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    /// 串行队列:串行化连接的读写与缓存访问,避免数据竞争
    private let queue = DispatchQueue(label: "kanata-client")
    /// 目标 layer 不存在时回退到的默认 layer(类型级常量,供属性初始化器引用)
    private static let fallbackLayer = "base"
    /// 单次重连间隔(秒)
    private static let reconnectDelay: TimeInterval = 5

    /// 最近一次意图切换到的 layer
    private var lastLayer = KanataClient.fallbackLayer
    private var layerNames: Set<String> = []
    private var connection: NWConnection?
    /// 在 TCP 之上挂载按行分帧器的连接参数,使收发两侧都以「一条完整 JSON」为单位
    private var parameters: NWParameters {
        let framer = NWProtocolFramer.Options(definition: NewlineFramer.definition)
        let parameters = NWParameters.tcp
        parameters.defaultProtocolStack.applicationProtocols.insert(framer, at: 0)
        return parameters
    }

    init(host: String = "127.0.0.1", port: NWEndpoint.Port) {
        self.host = .init(host)
        self.port = port
    }

    /// 建立常驻连接并开始读取(连接断开时自动重连)。
    func start() {
        queue.async { [self] in connect() }
    }

    private func connect() {
        let conn = NWConnection(host: host, port: port, using: parameters)
        connection = conn
        conn.stateUpdateHandler = { [self] state in
            switch state {
            case .ready:
                // 连接就绪后请求一次 layer 名以填充缓存
                writeToKanata(.RequestLayerNames)
                // 补发最近一次 layer
                changeLayer(lastLayer)
            case .waiting, .failed, .cancelled:
                reconnect()
            default:
                break
            }
        }
        readFromKanata(conn)
        conn.start(queue: queue)
    }

    /// 统一的重连入口:取消当前连接并延时重连。
    /// 以 `connection` 是否为 nil 作幂等守卫,使 stateUpdateHandler 与 receive 回调
    /// 的多次触发只会调度一次重连,避免重连风暴。
    private func reconnect() {
        guard let conn = connection else { return }
        connection = nil  // 置空后再取消,cancel 引发的 .cancelled 回调将被守卫拦下
        conn.cancel()
        queue.asyncAfter(deadline: .now() + KanataClient.reconnectDelay) { [self] in connect() }
    }

    /// 切换到与 `layer` 匹配的 layer;不在已知 layer 列表时回退到 fallbackLayer。
    func changeLayer(_ layer: String) {
        queue.async { [self] in
            let target = layerNames.contains(layer) ? layer : KanataClient.fallbackLayer
            lastLayer = target
            writeToKanata(.ChangeLayer(new: target)) {
                print("ChangeLayer -> \(target) (desired: \(layer))")
            }
        }
    }

    /// 发送一条消息;`onSent` 仅在数据成功交付网络栈后回调(在串行 queue 上执行)。
    /// 断连时 connection 为 nil,send 不执行,onSent 不触发——从而日志只记录「实际发出」。
    private func writeToKanata(_ message: ClientMessage, onSent: (() -> Void)? = nil) {
        connection?.send(
            content: try! encoder.encode(message),
            completion: .contentProcessed { error in
                if let error {
                    print("send failed: \(error.localizedDescription)")
                    return
                }
                onSent?()
            }
        )
    }

    private func readFromKanata(_ conn: NWConnection) {
        conn.receiveMessage { [self] content, _, _, error in
            // 出错或流结束(framer 下 content == nil 即表示流结束):走统一入口重连
            guard let content, error == nil else {
                print("receive error: \(error?.localizedDescription ?? "stream ended")")
                reconnect()
                return
            }
            if let message = try? decoder.decode(ServerMessage.self, from: content),
                let names = message.LayerNames?.names
            {
                layerNames = Set(names)
            }
            readFromKanata(conn)  // 继续读取后续推送
        }
    }
}

var frontmostAppIdPublisher: AnyPublisher<String, Never> {
    return NSWorkspace.shared.notificationCenter
        .publisher(for: NSWorkspace.didActivateApplicationNotification)
        .compactMap { event in
            let app = event.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
            return app?.bundleIdentifier
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
}

let client = KanataClient(port: kanataPort)
client.start()

let subscription = frontmostAppIdPublisher.sink { appID in
    client.changeLayer(appID)
}

RunLoop.main.run()
