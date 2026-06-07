#!/usr/bin/env fish

# ▁▂▃▄▅▆▇█
# tier8 ▏ 🌑 90%-100%
# tier7 ▎ 🌒 80%-90%
# tier6 ▍ 🌒 70%-80%
# tier5 ▌ 🌓 60%-70%
# tier4 ▋ 🌓 50%-60%
# tier3 ▊ 🌔 40%-50%
# tier2 ▉ 🌔 30%-40%
# tier1 █ 🌕 0%-30%
function pct_icon
    set pct $argv[1]

    if test $pct -ge 90
        echo 🌑
    else if test $pct -ge 80
        echo 🌒
    else if test $pct -ge 70
        echo 🌒
    else if test $pct -ge 60
        echo 🌓
    else if test $pct -ge 50
        echo 🌓
    else if test $pct -ge 40
        echo 🌔
    else if test $pct -ge 30
        echo 🌔
    else
        echo 🌕
    end
end
