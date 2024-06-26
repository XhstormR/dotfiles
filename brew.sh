#!/usr/bin/env bash

brew update
brew upgrade

brew install eza
brew install btop
brew install coreutils
brew install hugo
brew install moar
brew install nnn
brew install chafa
brew install sniffnet
brew install sevenzip
brew install zoxide
brew install micromamba

brew install --cask aural
brew install --cask android-file-transfer
brew install --cask alacritty
brew install --cask amethyst
brew install --cask maccy
brew install --cask alt-tab
brew install --cask keepingyouawake
brew install --cask clashx
brew install --cask google-chrome
brew install --cask iina
brew install --cask intellij-idea
brew install --cask itsycal
brew install --cask karabiner-elements
brew install --cask keepassxc
brew install --cask maczip
brew install --cask middleclick
brew install --cask megasync
brew install --cask macfuse
brew install --cask mounty
brew install --cask onyx
brew install --cask orbstack
brew install --cask phoenix-slides
brew install --cask rectangle
brew install --cask stats
brew install --cask shottr
brew install --cask sloth
brew install --cask syncthing
brew install --cask sublime-text
brew install --cask telegram
brew install --cask macwhisper

brew cleanup --prune=all
