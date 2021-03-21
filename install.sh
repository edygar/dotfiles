#!/bin/sh
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "=== Install devtools if needed ==="
    xcode-select --install

    echo "=== Installing .dotfiles for the first time ==="
    git clone --depth=1 https://github.com/edygar/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
else
    cd "$HOME/.dotfiles"
fi

echo "=== Installing Brew ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

cd ~/.dotfiles
echo "=== Installing bundled applications ==="
brew update
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

echo "=== Installing Node ==="
if [ ! -f "~/.nvm" ]; then
    mkdir ~/.nvm
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Installing Node
nvm install node
nvm use node
nvm alias default node

echo "=== Installing neovim dependencies ==="
# Installing neovim's dependencies
sudo gem install neovim
pip install --user pynvim
npm install -g neovim prettier typescript typescript-language-server eslint markdownlint prettier-eslint

echo "=== Fetching Oh-My-Zsh custom plugins ==="
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
