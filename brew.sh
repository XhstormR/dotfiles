#!/usr/bin/env bash

brew update
brew upgrade --greedy --force-bottle

brew install sniffnet
brew install sevenzip

brew install --cask alacritty
brew install --cask amethyst
brew install --cask background-music
brew install --cask deskpad
brew install --cask maccy
brew install --cask alt-tab
brew install --cask keepingyouawake
brew install --cask google-chrome
brew install --cask vlc
brew install --cask iina
brew install --cask intellij-idea
brew install --cask itsycal
brew install --cask jordanbaird-ice
brew install --cask karabiner-elements
brew install --cask keepassxc
brew install --cask maczip
brew install --cask middleclick
brew install --cask onyx
brew install --cask phoenix-slides
brew install --cask rectangle
brew install --cask stats
brew install --cask snipaste
brew install --cask sloth
brew install --cask telegram
#brew install --cask android-file-transfer
#brew install --cask megasync
#brew install --cask macfuse
#brew install --cask mounty
#brew install --cask orbstack
#brew install --cask macwhisper

brew cleanup --prune=all
