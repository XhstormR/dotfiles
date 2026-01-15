#!/usr/bin/env fish

function hostip
    switch (uname)
        case Darwin
            ipconfig getifaddr en0
        case Linux Windows_NT 'MINGW64_NT*'
            hostname -i
        case '*'
            echo "不支持的操作系统: $(uname)"
    end
end
