#!/usr/bin/env bash

packages=(
    aria2
    bat
    btop
    htop
    chafa
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
    vim
    yt-dlp
    yazi
    openjdk
)

micromamba update --all

micromamba install ${packages[@]}

micromamba clean --all
