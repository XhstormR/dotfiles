#!/usr/bin/env bash

packages=(
    7zip
    aria2
    bat
    eza
    dua-cli
    syncthing
    less
    hugo
    resvg
    doxx
    chafa
    curl
    fish
    sed
    gawk
    git-delta
    lazygit
    lazydocker
    hexyl
    openssl
    jq
    xan
    watchexec
    socat
    sing-box
    tmux
    yazi
    whisper.cpp
    duckdb-cli
    navi
    sendme
    dumbpipe
    tesseract

    fd-find
    fzf
    zoxide
    ripgrep
    ast-grep

    util-linux
    uutils-coreutils
    moreutils
    toybox

    btop
    bottom
    rustnet
    witr

    poppler
    pandoc
    typst
    qpdf

    fresh-editor
    msedit
    vim

    # openjdk
    graalvm
    bun
    uv

    yt-dlp
    ffmpeg
    exiftool
    mediainfo

    lima
    docker-cli
    docker-compose

    # alacritty
    ghostty
    zed
)

pixi self-update

pixi global update

pixi global install --channel https://prefix.dev/github-releases --channel conda-forge ${packages[@]}

pixi clean cache -y
