#!/usr/bin/env bash

function doSync() {
    rsync \
        --exclude ".git/" \
        --exclude ".idea/" \
        --exclude "/*.sh" \
        --exclude "/README.md" \
        --exclude "/LICENSE" \
        -avhP --no-perms . ~;
}

function doIt() {
    doSync

    addMCP

    curl -o ~/.config/alacritty/dracula.toml https://raw.githubusercontent.com/dracula/alacritty/master/dracula.toml

    curl -O https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMonoNormal-NF-CN-unhinted.zip
    unzip -o MapleMonoNormal-NF-CN-unhinted.zip -d ~/Library/Fonts/
    rm MapleMonoNormal-NF-CN-unhinted.zip

    sh <(curl https://raw.githubusercontent.com/prefix-dev/pixi/refs/heads/main/install/install.sh)

    ln -s ~/.config/Code/User ~/Library/'Application Support'/Code/User
}

function addMCP() {
    claude mcp add --scope user --transport stdio sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking@latest
    claude mcp add --scope user --transport stdio context7 -- npx -y @upstash/context7-mcp@latest
    claude mcp add --scope user --transport stdio playwright-mcp -- npx -y @playwright/mcp@latest
    claude mcp add --scope user --transport stdio chrome-devtools-mcp -- npx -y chrome-devtools-mcp@latest
    claude mcp add --scope user --transport http  grep -- https://mcp.grep.app

    claude mcp add --scope user --transport stdio angular-cli -- npx -y @angular/cli@latest mcp
    claude mcp add --scope user --transport stdio daisyui-doc -- npx -y mcp-remote@latest https://gitmcp.io/saadeghi/daisyui
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
