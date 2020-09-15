#!/usr/bin/env bash

echo "=== Installing Brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

cd ~/.dotfiles
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
for file in vimrc zshrc gitconfig ctags; do
  if [[ -f "~/.$file" ]]; then
    mv "~/.$file" "~/.$file.bkp"
  fi

  ln -nfs ~/.dotfiles/$file ~/.$file
done;

source ~/.zshrc

echo "=== Installing dependencies ==="
if [ ! -f "~/.nvm" ]; then
    mkdir ~/.nvm
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm install node
nvm use node
nvm alias default node

sudo gem install neovim
pip install --user pynvim

npm install -g neovim
npm install -g typescript typescript-language-server
