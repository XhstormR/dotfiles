#!/usr/bin/env bash

packages=(
    aria2
    bat
    curl
    exa
    fd-find
    fish
    fzf
    gawk
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
