#!/usr/bin/env bash

packages=(
    7zip
    aria2
    bat
    btop
    bottom
    dua-cli
    uutils-coreutils
    eza
    syncthing
    less
    hugo
    chafa
    curl
    fd-find
    fish
    fzf
    ffmpeg
    sed
    gawk
    git-delta
    lazygit
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
    duckdb-cli

    lima-vm
    docker-cli
    docker-compose

    alacritty
    zed
)

pixi self-update

pixi global update

pixi global install ${packages[@]}
pixi global install openjdk --expose java --expose javac --expose jar --expose jwebserver

pixi clean cache -y
