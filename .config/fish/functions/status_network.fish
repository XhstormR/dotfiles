#!/usr/bin/env fish

function status_network
    if string match -q '*<BODY>Success<*' (curl --silent --max-time 3 http://captive.apple.com 2>/dev/null)
        echo 🟢
    else
        echo 🔴
    end
end
