#!/usr/bin/env bash

function doIt() {
    # 关闭 Spotlight 索引
    sudo mdutil -a -i off
    # MacOS: Remove Caps Lock delay
    hidutil property --set '{"CapsLockDelayOverride":0}'

    # 关闭智能引号、智能破折号、句号替换、自动大写首字母，显示隐藏文件，Ctrl+Cmd+Drag
    defaults write -g AppleShowScrollBars -string "Always"
    defaults write -g AppleShowAllFiles -bool true
    defaults write -g AppleShowAllExtensions -bool true
    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g NSAutomaticCapitalizationEnabled -bool false
    defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
    defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
    defaults write -g NSWindowShouldDragOnGesture -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # 设置默认应用
    duti -s dev.zedapp.zed sh all
    duti -s dev.zedapp.zed md all
    duti -s dev.zedapp.zed vtt all
    duti -s dev.zedapp.zed txt all
    duti -s dev.zedapp.zed csv all
    duti -s dev.zedapp.zed json all
    duti -s dev.zedapp.zed public.text all
    duti -s com.google.Chrome pdf all
    duti -s com.google.Chrome html all
    duti -s com.colliderli.iina aac all
    duti -s com.colliderli.iina mp3 all
    duti -s com.colliderli.iina mp4 all
    duti -s com.colliderli.iina m4a all
    duti -s com.colliderli.iina wav all
    duti -s com.colliderli.iina flac all
    duti -s net.blyt.phoenixslides jpg all
    duti -s net.blyt.phoenixslides png all
    duti -s net.blyt.phoenixslides gif all

    mkdir -p ~/Library/'Application Support'/Code
    ln -s ~/.config/Code/User ~/Library/'Application Support'/Code

         cp ../.config/kanata/kanata-layer-daemon.plist ~/Library/LaunchAgents/
    sudo cp ../.config/kanata/kanata.plist /Library/LaunchDaemons/

    curl -O https://github.com/subframe7536/maple-font/releases/download/v8.0-beta.3/MapleMonoNormal-NF-CN-unhinted.zip
    unzip -o MapleMonoNormal-NF-CN-unhinted.zip -d ~/Library/Fonts/
    rm MapleMonoNormal-NF-CN-unhinted.zip
}

cd "$(dirname "${BASH_SOURCE}")" || exit;

if [ "$1" == "--force" ] || [ "$1" == "-F" ]; then
    doIt;
else
    read -r -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
