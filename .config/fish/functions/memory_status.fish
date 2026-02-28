#!/usr/bin/env fish

function memory_status
    switch (uname)
        case Darwin
            __darwin_memory_status
        case '*'
            echo "不支持的操作系统: $(uname)"
    end
end

# OSX Activity monitor formulas
# https://github.com/samoshkin/tmux-plugin-sysstat
# https://github.com/exelban/stats/blob/master/Modules/RAM/readers.swift
function __darwin_memory_status
    set sizeTier (math 2^30) # GB: 1024 * 1024 * 1024
    set vmstat (
        set pages (vm_stat | string match -r [0-9]+)
        set page_size $pages[1]
        for page in $pages
            math $page x $page_size / $sizeTier
        end
    )

    # 总内存
    # set total (math (sysctl -n hw.memsize) / $sizeTier)
    set total (math $vmstat[2] + $vmstat[3] + $vmstat[4] + $vmstat[5] + $vmstat[6] + $vmstat[7] + $vmstat[17])
    # 联动内存
    set pwired $vmstat[7]
    # 可回收内存
    set ppurge $vmstat[8]
    # 匿名内存
    set panon $vmstat[15]
    # 被压缩内存
    set pcomp $vmstat[17]
    # 应用内存
    set papp (math $panon - $ppurge)
    # 已用内存
    set used (math $papp + $pwired + $pcomp)
    # 可用内存
    set free (math $total - $used)
    # 使用率
    set usage_pct (math "round($used / $total * 100)")
    # 使用率图标
    set usage_icon (__pct_icon $usage_pct)

    printf '%.0f/%.0fGB %s\n' $used $total $usage_icon

    ## 进度条
    #set bar_len 20
    #set filled (math "round($used / $total * $bar_len)")
    #set empty  (math "$bar_len - $filled")
    #set bar ""
    #for i in (seq $filled); set bar "$bar█"; end
    #for i in (seq $empty);  set bar "$bar░"; end

    #echo
    #printf '── 内存概况 ──\n'
    #echo
    #printf '  总内存    %.2f GB\n' $total
    #printf '  已用内存  %.2f GB  [%s] %s%%\n' $used $bar $usage_pct
    #printf '  可用内存  %.2f GB\n' $free
    #echo
    #printf '── 内存占用 ──\n'
    #echo
    #printf '  应用内存  %.2f GB\n' $papp
    #printf '  联动内存  %.2f GB\n' $pwired
    #printf '  被压缩    %.2f GB\n' $pcomp
    #echo
end

# tier5 🌑 90%-100%
# tier4 🌒 70%-90%
# tier3 🌓 50%-70%
# tier2 🌔 30%-50%
# tier1 🌕 0%-30%
function __pct_icon
    set pct $argv[1]

    if test $pct -ge 90
        echo 🌑
    else if test $pct -ge 70
        echo 🌒
    else if test $pct -ge 50
        echo 🌓
    else if test $pct -ge 30
        echo 🌔
    else
        echo 🌕
    end
end
