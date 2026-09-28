#!/usr/bin/env bash

packages=(
    git
    7zip
    zstd
    aria2
    bat
    eza
    dua-cli
    rsync
    syncthing
    caddy
    less
    hugo
    resvg
    doxx
    leaf-markdown-viewer
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
    yq
    magika-cli
    wifit3
    xan
    watchexec
    socat
    sing-box
    tmux
    yazi
    rclone
    whisper.cpp
    navi
    tesseract
    fastfetch

    sendme
    dumbpipe
    tailcat
    cloudflared
    croc
    uniclip

    fd-find
    fff-mcp
    fzf
    zoxide
    tgrep
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
    tectonic
    qpdf
    pdf-inspector
    markitdown

    fresh-editor
    msedit
    vim

    duckdb-cli
    redis-server
    turso

    yt-dlp
    ffmpeg
    caesiumclt
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
    yamlstar
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

pixi global install --channel https://prefix.dev/github-releases --channel conda-forge "${packages[@]}"

pixi clean cache -y
