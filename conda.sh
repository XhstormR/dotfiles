#!/usr/bin/env bash

packages=(
    aria2
    bat
    bpytop
    curl
    exa
    fd-find
    fish
    fzf
    gawk
    htop
    jq
    pycrypto
    pycurl
    ripgrep
    socat
    tmux
    trash-cli
    vim
    youtube-dl
    zoxide
)

conda update --all

conda install ${packages[@]}

conda clean --all
