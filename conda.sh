#!/usr/bin/env bash

packages=(
    7zip
    aria2
    bat
    eza
    dua-cli
    uutils-coreutils
    moreutils
    syncthing
    less
    hugo
    resvg
    chafa
    curl
    fish
    sed
    gawk
    git-delta
    lazygit
    hexyl
    jq
    socat
    tmux
    yazi
    whisper.cpp
    duckdb-cli

    fd-find
    fzf
    zoxide
    ripgrep
    ast-grep

    btop
    bottom

    poppler
    qpdf

    fresh-editor
    msedit
    vim

    openjdk
    bun
    uv

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
