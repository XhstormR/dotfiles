#!/usr/bin/env fish

function cpu_count
    set num (
        getconf _NPROCESSORS_ONLN 2>/dev/null ||
        sysctl -n hw.ncpu 2>/dev/null ||
        nproc 2>/dev/null ||
        echo 1
    )
    echo $num
end
