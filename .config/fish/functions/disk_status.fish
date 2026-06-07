#!/usr/bin/env fish

function disk_status
    set stats (df --output='used,size,pcent' -- / | string match -ra [0-9]+)
    set used $stats[1]
    set total $stats[2]
    set pcent $stats[3]
    set pcent_icon (pct_icon $pcent)

    printf '%.0f/%.0fGB %s\n' $used $total $pcent_icon
end
