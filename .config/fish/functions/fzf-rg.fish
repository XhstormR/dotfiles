#!/usr/bin/env fish

function fzf-rg --description 'Live ripgrep'
    set -l cmd_prefix 'rg --no-heading --column --color=always --'
    set -l preview_cmd 'bat --color=always --theme="Catppuccin Latte" --highlight-line {2} -- {1}'
    set -l files (fzf \
        --disabled \
        --query "$argv" \
        --bind "start:reload($cmd_prefix {q} || true)" \
        --bind "change:reload($cmd_prefix {q} || true)" \
        --bind "ctrl-o:execute-silent($EDITOR {1}:{2}:{3})" \
        --bind "f2:execute(cat {1})" \
        --bind "focus:bg-transform-header(file -bI {1})" \
        --footer 'Enter insert files, Ctrl-O open in $EDITOR, F2 cat' \
        --prompt='Search> ' \
        --preview $preview_cmd \
        --preview-window '~4,+{2}/3,<80(up)' \
        --delimiter ':' \
        --accept-nth=1 \
        --layout=reverse \
        | path sort -u
    )
    if set -q files[1]
        commandline -- (string escape -- $files | string join ' ')
    end
end
