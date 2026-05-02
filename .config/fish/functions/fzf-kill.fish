#!/usr/bin/env fish

function fzf-kill
    set -l cmd_prefix 'ps -e -opid,user,command'
    set -l cmd_selected (fzf \
        --bind "start:reload($cmd_prefix)" \
        --bind "ctrl-r:reload($cmd_prefix)" \
        --bind "enter:execute-silent(kill -9 {1})+reload($cmd_prefix)" \
        --header 'Press Enter to kill
Press CTRL-R to reload' \
        --header-lines=1 \
        --prompt='Processes> ' \
        --preview='ps -f -p {1} || echo "Cannot preview {1} because it exited."' \
        --preview-window="down:4:wrap" \
        --layout=reverse \
    )
    set -l pids_selected (printf '%s\n' $cmd_selected | awk '{print $1}')
    if test -n "$pids_selected"
        kill -9 $pids_selected
    end
end
