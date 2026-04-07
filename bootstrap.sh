#!/usr/bin/env bash

function doIt() {
    doSync

    addMCP

    setupMac

    sh <(curl https://raw.githubusercontent.com/prefix-dev/pixi/refs/heads/main/install/install.sh)

    sh <(curl https://raw.githubusercontent.com/PeonPing/peon-ping/main/install.sh)

    curl -O https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMonoNormal-NF-CN-unhinted.zip
    unzip -o MapleMonoNormal-NF-CN-unhinted.zip -d ~/Library/Fonts/
    rm MapleMonoNormal-NF-CN-unhinted.zip

    mkdir -p ~/Library/'Application Support'/Code
    ln -s ~/.config/Code/User ~/Library/'Application Support'/Code
}

function doSync() {
    rsync \
        --exclude ".git/" \
        --exclude ".idea/" \
        --exclude "/*.sh" \
        --exclude "/README.md" \
        --exclude "/LICENSE" \
        -avhP --no-perms . ~;
}

function addMCP() {
    claude mcp add --scope user --transport stdio sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking@latest
    claude mcp add --scope user --transport stdio context7 -- npx -y @upstash/context7-mcp@latest
    claude mcp add --scope user --transport stdio playwright-mcp -- npx -y @playwright/mcp@latest
    claude mcp add --scope user --transport stdio markitdown-mcp -- uvx markitdown-mcp@latest
    claude mcp add --scope user --transport stdio chrome-devtools-mcp -- npx -y chrome-devtools-mcp@latest
    claude mcp add --scope user --transport stdio code-review-graph -- uvx code-review-graph@latest serve
    claude mcp add --scope user --transport http  grep -- https://mcp.grep.app

    claude mcp add --scope user --transport stdio svelte -- npx -y @sveltejs/mcp@latest
    claude mcp add --scope user --transport stdio angular-cli -- npx -y @angular/cli@latest mcp
    claude mcp add --scope user --transport stdio daisyui-doc -- npx -y mcp-remote@latest https://gitmcp.io/saadeghi/daisyui
    claude mcp add --scope user --transport http  astro-docs -- https://mcp.docs.astro.build/mcp
    claude mcp add --scope user --transport http  atlassian-mcp-server -- https://mcp.atlassian.com/v1/mcp
    claude mcp add --scope user --transport http  gitlab-cmc -H "X-Gitlab-Mcp-Server-Tool-Name-Prefix: cmc_" -- https://git.coinmarketcap.supply/api/v4/mcp
}

function setupMac() {
    # MacOS: Remove Caps Lock delay
    hidutil property --set '{"CapsLockDelayOverride":0}'

    # 关闭智能引号、智能破折号、句号替换、自动大写首字母，显示隐藏文件
    defaults write -g NSAutomaticCapitalizationEnabled -bool false
    defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
    defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
    defaults write -g NSWindowShouldDragOnGesture -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # 设置默认应用
    duti -s com.google.Chrome pdf all
    duti -s com.google.Chrome html all
    duti -s dev.zedapp.zed-0 sh all
    duti -s dev.zedapp.zed-0 txt all
    duti -s dev.zedapp.zed-0 fish all
    duti -s dev.zedapp.zed-0 json all
    duti -s com.colliderli.iina aac all
    duti -s com.colliderli.iina mp3 all
    duti -s com.colliderli.iina m4a all
    duti -s com.colliderli.iina wav all
    duti -s com.colliderli.iina flac all
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
