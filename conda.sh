#!/usr/bin/env bash

packages=(
    aria2
    bat
    btop
    curl
    fd-find
    fish
    fzf
    sed
    gawk
    git-delta
    htop
    hexyl
    jq
    pycrypto
    pycurl
    ripgrep
    socat
    tmux
    trash-cli
    vim
    yt-dlp
    openjdk
)

micromamba update --all

micromamba install ${packages[@]}

micromamba clean --all
