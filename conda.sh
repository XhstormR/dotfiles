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
    kanata
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

    lima-vm
    docker-cli
    docker-compose

    # Languages
    bun
    quickjs
    uv
    # openjdk

    # Dynamic Library
    onnxruntime-cpp
)

packages_github=(
    graalvm
    yamlstar
    cloudflared
    rustnet
)

pixi self-update

pixi global update

pixi global install --channel conda-forge "${packages[@]}"
pixi global install --channel https://prefix.dev/github-releases "${packages_github[@]}"

pixi clean cache -y
