#!/usr/bin/env bash

brew update
brew upgrade

brew install coreutils
brew install git-delta
brew install gnu-sed
brew install hugo
brew install less
brew install nnn
brew install viu
brew install sevenzip
brew install zoxide

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
brew install --cask megasync
brew install --cask miniconda
brew install --cask macfuse
brew install --cask mounty
brew install --cask onyx
brew install --cask qview
brew install --cask rectangle
brew install --cask stats
brew install --cask shottr
brew install --cask telegram

brew cleanup --prune=all
