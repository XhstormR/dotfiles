#!/usr/bin/env fish

function uptime
    set -l diff (expr (date +%s) - (date -d (command uptime -s) +%s))
    set -l d (math --scale 0 $diff / 86400); set diff (math $diff % 86400)
    set -l h (math --scale 0 $diff /  3600); set diff (math $diff %  3600)
    set -l m (math --scale 0 $diff /    60); set diff (math $diff %    60)
    printf "%02dd %02dh %02dm\n" $d $h $m
end
