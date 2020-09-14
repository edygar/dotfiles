#!/usr/bin/env bash

echo "=== Installing Brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "=== Installing bundled applications ==="
brew bundle

echo "=== Installing ZSH ==="
export ZSH="$HOME/.dotfiles/oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > "$ZSH/custom/themes/gruvbox.zsh-theme"

echo "=== iTerm Setup ==="
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/iTerm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
killall cfprefsd

echo "=== Installing ==="
mkdir -p ~/.config
ln -nfs ~/.dotfiles/nvim ~/.config/nvim

echo "=== Link config files ==="
for file in .vimrc .zshrc; do
  if [[ -f "~/$file" ]]; then
    mv "~/$file" "~/$file.bkp"
  fi

  ln -nfs ~/.dotfiles/$file ~/$file
done;

zsh
