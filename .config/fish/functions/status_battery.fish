#!/usr/bin/env fish

function status_battery
    set battery 🔋
    set low_battery 🪫

    switch (uname)
        case Darwin
            set capacity (fastfetch --json --pipe --structure Battery | jq '.[0].result[0].capacity | floor')
        case Linux
            set capacity (cat /sys/class/power_supply/BAT0/capacity)
        case '*'
            echo "不支持的操作系统: $(uname)"
            return 1
    end

    if test "$capacity" -gt 40
        echo $capacity%" "$battery
    else
        echo $capacity%" "$low_battery
    end
end
