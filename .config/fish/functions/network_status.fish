#!/usr/bin/env fish

function network_status
    if string match -q '*<BODY>Success<*' (curl --silent --max-time 3 http://captive.apple.com 2>/dev/null)
        echo 🟢
    else
        echo 🔴
    end
end
