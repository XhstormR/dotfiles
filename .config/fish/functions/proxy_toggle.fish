#!/usr/bin/env fish

function __proxy_on
    set -xU all_proxy socks5h://127.0.0.1:1080
    set -xU http_proxy http://127.0.0.1:1080
    set -xU https_proxy http://127.0.0.1:1080
    set -xU ALL_PROXY $all_proxy
    set -xU HTTP_PROXY $http_proxy
    set -xU HTTPS_PROXY $https_proxy
    set -xU GIT_SSH_COMMAND 'ssh -o ProxyCommand="socat - PROXY:127.0.0.1:%h:%p,proxyport=1080"'
    set -xU JDK_JAVA_OPTIONS '-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080'
end

function __proxy_off
    set -e all_proxy
    set -e http_proxy
    set -e https_proxy
    set -e ALL_PROXY
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    set -e GIT_SSH_COMMAND
    set -e JDK_JAVA_OPTIONS
end

function proxy_toggle
    if set -q all_proxy
        __proxy_off
    else
        __proxy_on
    end
    true
end
