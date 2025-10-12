#!/usr/bin/env bash

packages=(
    aria2
    bat
    btop
    dua-cli
    uutils-coreutils
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
    zed
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
pixi global install openjdk --expose java --expose javac --expose jar --expose jwebserver

pixi clean cache -y
