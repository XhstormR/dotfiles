#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    rsync --exclude ".git/" \
        --exclude ".idea/" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE" \
        -avh --no-perms . ~;

    curl -o ~/.config/alacritty/dracula.yml https://raw.githubusercontent.com/dracula/alacritty/master/dracula.yml

    curl -o /usr/local/bin/fzf-tmux https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux && chmod +x /usr/local/bin/fzf-tmux
    curl -o ~/.config/fish/functions/fzf_key_bindings.fish https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.fish

    curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
    curl -o ~/.config/fish/functions/n.fish https://raw.githubusercontent.com/jarun/nnn/master/misc/quitcd/quitcd.fish

    curl -o ~/.config/fish/conf.d/z.fish https://raw.githubusercontent.com/skywind3000/z.lua/master/init.fish
    curl -o ~/.config/fish/conf.d/z.lua https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -r -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
