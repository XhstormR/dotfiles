#!/usr/bin/env bash

function doIt() {
    doSync

    sh <(curl https://raw.githubusercontent.com/prefix-dev/pixi/refs/heads/main/install/install.sh)

    curl --output-dir ~/.local/bin -O https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/bin/fzf-preview.sh
    chmod +x ~/.local/bin/fzf-preview.sh

    ya pkg install # Yazi
}

function doSync() {
    rsync \
        --exclude ".git/" \
        --exclude ".idea/" \
        --exclude "osx/" \
        --exclude "win/" \
        --exclude "/*.sh" \
        --exclude "/ui.png" \
        --exclude "/README.md" \
        --exclude "/LICENSE" \
        -avhP --no-perms . ~;

    if [ "$(uname)" == "Darwin" ]; then
        rsync --exclude "/*.sh" -avhP --no-perms osx/ ~;
    fi;
}

cd "$(dirname "${BASH_SOURCE}")" || exit;

if [ "$1" == "--force" ] || [ "$1" == "-F" ]; then
    doIt;
elif [ "$1" == "--sync" ] || [ "$1" == "-S" ]; then
    doSync;
else
    read -r -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
