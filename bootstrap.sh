#!/usr/bin/env bash

function doSync() {
    rsync \
        --exclude ".git/" \
        --exclude ".idea/" \
        --exclude "/*.sh" \
        --exclude "/README.md" \
        --exclude "/LICENSE" \
        -avh --no-perms . ~;
}

function doIt() {
    doSync

    curl -o ~/.config/alacritty/dracula.toml https://raw.githubusercontent.com/dracula/alacritty/master/dracula.toml

    curl -o ~/.config/fish/conf.d/zoxide.fish https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/init.fish

    curl -o ~/.local/bin/fzf-tmux https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux && chmod +x ~/.local/bin/fzf-tmux

    curl -o ~/Library/Fonts/"JetBrainsMonoNerdFont-Regular.ttf" "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
}

cd "$(dirname "${BASH_SOURCE}")" || exit;

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    doIt;
elif [ "$1" == "--sync" ] || [ "$1" == "-s" ]; then
    doSync;
else
    read -r -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
