#!/usr/bin/env bash

packages=(
    7zip
    aria2
    bat
    btop
    bottom
    dua-cli
    uutils-coreutils
    moreutils
    eza
    syncthing
    less
    hugo
    poppler
    resvg
    chafa
    curl
    fd-find
    fish
    fzf
    sed
    gawk
    git-delta
    lazygit
    hexyl
    jq
    zoxide
    ripgrep
    ast-grep
    socat
    tmux
    vim
    yazi
    whisper.cpp
    duckdb-cli

    openjdk
    bun

    yt-dlp
    ffmpeg
    exiftool
    mediainfo

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
