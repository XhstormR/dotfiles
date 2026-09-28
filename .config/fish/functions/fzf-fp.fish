#!/usr/bin/env fish

function fzf-fp --description '[F]ind [P]ath: Enter list executables, Esc back/exit'
    while set dir (path filter -d $PATH | fzf --header='[find:path]' --layout=reverse --preview='path filter -fx {}/* | path basename')
        path filter -fx $dir/* | path basename | fzf --header="[find:exe] => $dir" --layout=reverse >/dev/null
    end
end
