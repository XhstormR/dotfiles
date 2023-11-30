#!/usr/bin/env bash

packages=(
    aria2
    bat
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
)

micromamba update --all

micromamba install ${packages[@]}

micromamba clean --all
