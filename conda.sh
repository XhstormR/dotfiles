#!/usr/bin/env bash

packages=(
    aria2
    bat
    btop
    eza
    syncthing
    moar
    hugo
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

micromamba self-update

micromamba update --all

micromamba install ${packages[@]}

micromamba clean --all
