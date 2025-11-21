#!/usr/bin/env fish

function __proxy_on
    set -xU all_proxy socks5h://127.0.0.1:1080
    set -xU http_proxy http://127.0.0.1:1080
    set -xU https_proxy http://127.0.0.1:1080
    set -xU GIT_SSH_COMMAND 'ssh -o ProxyCommand="socat - PROXY:127.0.0.1:%h:%p,proxyport=1080"'
end

function __proxy_off
    set -e all_proxy
    set -e http_proxy
    set -e https_proxy
    set -e GIT_SSH_COMMAND
end

function proxy_toggle
    if set -q all_proxy
        __proxy_off
    else
        __proxy_on
    end
    true
end
