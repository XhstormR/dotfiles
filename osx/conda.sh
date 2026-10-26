#!/usr/bin/env bash

packages=(
    # Mac only
    paneru

    # GUI
    ghostty
    zed
    # alacritty
)

pixi global install --channel conda-forge "${packages[@]}"
