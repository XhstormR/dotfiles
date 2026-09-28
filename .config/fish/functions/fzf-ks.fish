#!/usr/bin/env fish

function fzf-ks --description '[K]ill [S]erver: Tab select, Enter kill, Esc exit'
    set -l sig 9
    set -q argv[1]; and set sig $argv[1]
    set -l cmd_prefix 'lsof -Pwni tcp -sTCP:LISTEN'
    fzf --multi \
        --bind "start:reload($cmd_prefix)" \
        --bind "ctrl-r:reload($cmd_prefix)" \
        --bind "enter:execute-silent(kill -$sig {+2})+clear-multi+reload($cmd_prefix)" \
        --header "Tab to select, Enter to kill -$sig
Press CTRL-R to reload" \
        --header-lines=1 \
        --prompt='TCP> ' \
        --preview='ps -f -p {2} || echo "Cannot preview {2} because it exited."' \
        --preview-window="down:4:wrap" \
        --layout=reverse >/dev/null
end
