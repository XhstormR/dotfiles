#!/usr/bin/env fish

function fzf-docker
    set -l list_cmd 'docker ps -a'
    set -l preview_cmd 'docker logs --tail 50 {1} 2>&1'
    set -l cid (fzf \
        --no-multi \
        --bind "start:reload($list_cmd)" \
        --bind "ctrl-r:reload($list_cmd)" \
        --header 'Press CTRL-R to reload' \
        --header-lines=1 \
        --prompt='Container> ' \
        --preview=$preview_cmd \
        --preview-window='down:50%:follow:wrap' \
        --accept-nth=1 \
        --layout=reverse \
    )
    and docker start $cid && docker exec -it $cid sh
end
