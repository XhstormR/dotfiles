#!/usr/bin/env fish

function list_path --description 'List existing directories in $PATH'
    path filter -d $PATH | path sort -u
end

function list_bin --description 'List executables in given directories'
    path filter -fx $argv/* | path basename
end

function fzf-fp --description '[F]ind [P]ath: Enter list executables, Esc back/exit'
    set -l preview_cmd 'path filter -fx {}/* | path basename'
    while set -l dir (list_path | fzf \
            --header='[find:path]' \
            --preview=$preview_cmd \
            --layout=reverse)
        list_bin $dir | fzf --header="[find:exe] => $dir" --layout=reverse
    end
end
