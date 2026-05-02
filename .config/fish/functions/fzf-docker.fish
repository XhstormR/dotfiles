#!/usr/bin/env fish

function fzf-docker
    set -l cmd_prefix 'docker ps -a'
    set -l cmd_selected (fzf \
        --bind "start:reload($cmd_prefix)" \
        --bind "ctrl-r:reload($cmd_prefix)" \
        --header 'Press CTRL-R to reload' \
        --header-lines=1 \
        --prompt='Container> ' \
        --preview='docker stats --no-stream {1} || echo "Cannot preview {1} because it exited."' \
        --preview-window="down:4:wrap" \
        --layout=reverse \
    )
    set -l cid_selected (printf '%s\n' $cmd_selected[1] | awk '{print $1}')
    if test -n "$cid_selected"
        docker start $cid_selected && docker exec -it $cid_selected sh
    end
end
