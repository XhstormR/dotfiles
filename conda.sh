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
    age
    jq
    magika-cli
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
    tailcat
    croc
    tesseract
    fastfetch

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
    pdf-inspector

    fresh-editor
    msedit
    vim

    yt-dlp
    ffmpeg
    exiftool
    mediainfo

    lima
    docker-cli
    docker-compose

    # Mac only
    paneru

    # Languages
    bun
    quickjs
    uv
    graalvm
    # openjdk

    # Dynamic Library
    onnxruntime-cpp

    # GUI
    ghostty
    zed
    # alacritty
)

pixi self-update

pixi global update

pixi global install --channel https://prefix.dev/github-releases --channel conda-forge ${packages[@]}

pixi clean cache -y
