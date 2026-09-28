#!/usr/bin/env fish

function fzf-kp --description '[K]ill [P]rocess: Tab select, Enter kill, Esc exit'
    set -l sig 9
    set -q argv[1]; and set sig $argv[1]
    set -l cmd_prefix 'ps -e -o pid,ppid,user,%cpu,%mem,etime,command'
    fzf --multi \
        --bind "start:reload($cmd_prefix)" \
        --bind "ctrl-r:reload($cmd_prefix)" \
        --bind "enter:execute-silent(kill -$sig {+1})+clear-multi+reload($cmd_prefix)" \
        --header "Tab to select, Enter to kill -$sig
Press CTRL-R to reload" \
        --header-lines=1 \
        --prompt='Processes> ' \
        --preview='ps -f -p {1} || echo "Cannot preview {1} because it exited."' \
        --preview-window="down:4:wrap" \
        --layout=reverse >/dev/null
end
