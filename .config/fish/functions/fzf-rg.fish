#!/usr/bin/env fish

function fzf-rg
    set -l cmd_prefix 'rg --no-heading --column --color=always --'
    set -l cmd_selected (fzf \
        --disabled \
        --query "$argv" \
        --bind "start:reload($cmd_prefix {q})" \
        --bind "change:reload($cmd_prefix {q} || true)" \
        --bind "ctrl-o:execute-silent($EDITOR --goto {1}:{2}:{3})" \
        --bind "f2:execute(cat {1})" \
        --bind "focus:bg-transform-header(file -bI {1})" \
        --prompt='Search> ' \
        --delimiter ':' \
        --preview 'bat --color=always --theme="Catppuccin Latte" --highlight-line {2} -- {1}' \
        --preview-window '~4,+{2}/3,<80(up)' \
        --layout=reverse \
    )
    set -l files_selected (printf '%s\n' $cmd_selected | awk -F: '{print $1}' | sort -u | string join ' ')
    if test -n "$files_selected"
        commandline $files_selected
    end
end
