#!/usr/bin/env bash

packages=(
    aria2
    bat
    btop
    eza
    syncthing
    moar
    hugo
    htop
    chafa
    curl
    fd-find
    fish
    fzf
    sed
    gawk
    git-delta
    hexyl
    jq
    zoxide
    ripgrep
    socat
    tmux
    vim
    yt-dlp
    yazi
    openjdk
)

pixi self-update

pixi global update

pixi global install ${packages[@]}

pixi clean cache -y
