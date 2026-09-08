#!/usr/bin/env fish

# 🌕
# 🌖
# 🌗
# 🌘
# 🌑
# 🌒
# 🌓
# 🌔
# 🌕
# 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛
#            
# ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
# ○ ◔ ◑ ◕ ●
function moon_spinner
    set phases 🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔
    while true
        for phase in $phases
            printf '\r%s' $phase
            sleep 0.08
        end
    end
end
