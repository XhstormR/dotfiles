#!/usr/bin/env fish

function fzf-kp --description '[K]ill [P]rocess: Tab select, Enter kill, Esc exit'
    set -l list_cmd 'ps -e -o pid,ppid,user,%cpu,%mem,etime,command'
    set -l preview_cmd 'ps -f -p {1} || echo "Cannot preview {1} because it exited."'
    fzf --multi \
        --bind "start:reload($list_cmd)" \
        --bind "ctrl-r:reload($list_cmd)" \
        --bind "enter:execute-silent(kill -9 {+1})+reload($list_cmd)+clear-multi" \
        --header "Tab to select, Enter to kill -9
Press CTRL-R to reload" \
        --header-lines=1 \
        --prompt='Processes> ' \
        --preview=$preview_cmd \
        --preview-window="down:4:wrap" \
        --layout=reverse
end
