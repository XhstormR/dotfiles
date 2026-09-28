#!/usr/bin/env fish

function status_battery
    set battery 🔋
    set low_battery 🪫

    switch (uname)
        case Darwin Windows_NT 'MINGW64_NT*' Linux
            set capacity (fastfetch --json --pipe --structure Battery | jq '.[0].result[0].capacity')
        case '*'
            echo "不支持的操作系统: $(uname)"
            return 1
    end

    set capacity (math "floor($capacity)")
    if test "$capacity" -gt 40
        echo $capacity%" "$battery
    else
        echo $capacity%" "$low_battery
    end
end
