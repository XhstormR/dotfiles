#!/usr/bin/env bash

formulae=(
    sniffnet
    flow-control
)

casks=(
    sfm
    vorssaint
    appcleaner
    loop
    rectangle
    tungsten-edge
    swift-shift
    amethyst
    deskpad
    opendisplay
    crisp
    markedit
    markdown-preview
    textgrabber2
    trex
    easydict
    copyq
    maccy
    uniclipboard
    meetily
    dockdoor
    alt-tab
    input-source-pro
    keepingyouawake
    google-chrome
    viz
    vlc
    iina
    intellij-idea
    itsycal
    thaw
    karabiner-elements
    keepassxc
    maczip
    middleclick
    mos
    obs
    onyx
    puremac
    phoenix-slides
    stats
    airstats
    mac-performance-monitor
    neohtop
    snipaste
    snapzy
    sloth
    solvespace
    revpdf-editor
    telegram
    visual-studio-code
    zedis
    handy
    paseo
    localsend
    photocraft
    robbietilton-compositor
    # android-file-transfer
    # background-music
    # megasync
    # macfuse
    # mounty
    # orbstack

    # Third-party taps
    getopenscreen/openscreen/openscreen
    abue-ammar/tinycast/tinycast
    66HEX/frame/frame
    pch/tap/rawmakase
)

brew update
brew upgrade --greedy --force-bottle

brew install "${formulae[@]}"
brew install --cask "${casks[@]}"

brew cleanup --prune=all
