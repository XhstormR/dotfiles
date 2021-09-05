#!/usr/bin/env bash

brew update
brew upgrade

brew install aria2
brew install coreutils
brew install git-delta
brew install gnu-sed
brew install hugo
brew install less
brew install nnn

brew install --cask alacritty
brew install --cask alfred
brew install --cask amethyst
brew install --cask cyberduck
brew install --cask google-chrome
brew install --cask iina
brew install --cask intellij-idea
brew install --cask itsycal
brew install --cask karabiner-elements
brew install --cask maczip
brew install --cask megasync
brew install --cask miniconda
brew install --cask mounty
brew install --cask onyx
brew install --cask rectangle
brew install --cask snipaste
brew install --cask vlc
brew install --cask xnviewmp

brew cleanup --prune=all
