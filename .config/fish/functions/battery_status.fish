#!/usr/bin/env fish

function battery_status
    set battery 🔋
    set low_battery 🪫

    switch (uname)
        case Darwin
            set capacity (pmset -g batt | string match -r "[0-9]{1,3}(?=%)")
        case Linux
            set capacity (cat /sys/class/power_supply/BAT0/capacity)
        case '*'
            echo "不支持的操作系统: $(uname)"
            return 1
    end

    if test "$capacity" -gt 40
        echo "$battery $capacity%"
    else
        echo "$low_battery $capacity%"
    end
end
