#!/usr/bin/env bash

packages=(
    aria2
    bat
    btop
    htop
    curl
    fd-find
    fish
    fzf
    sed
    gawk
    git-delta
    hexyl
    jq
    zoxide
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
