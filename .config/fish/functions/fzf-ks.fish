#!/usr/bin/env fish

function fzf-ks --description '[K]ill [S]erver: Tab select, Enter kill, Esc exit'
    set -l list_cmd 'lsof -Pwni tcp -sTCP:LISTEN'
    set -l preview_cmd 'ps -f -p {2} || echo "Cannot preview {2} because it exited."'
    fzf --multi \
        --bind "start:reload($list_cmd)" \
        --bind "ctrl-r:reload($list_cmd)" \
        --bind "enter:execute-silent(kill -9 {+2})+reload($list_cmd)+clear-multi" \
        --header "Tab to select, Enter to kill -9
Press CTRL-R to reload" \
        --header-lines=1 \
        --prompt='TCP> ' \
        --preview=$preview_cmd \
        --preview-window="down:4:wrap" \
        --layout=reverse
end
