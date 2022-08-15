#!/bin/sh
if [ ! -d "$HOME/.dotfiles" ]; then
	echo "=== Install devtools if needed ==="
	xcode-select --install

	echo "=== Installing .dotfiles for the first time ==="
	git clone --depth=1 https://github.com/edygar/dotfiles.git "$HOME/.dotfiles"
	cd "$HOME/.dotfiles" || exit 1
else
	cd "$HOME/.dotfiles" || exit 1
fi

echo "=== Installing Brew ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

cd "$HOME/.dotfiles" || exit 1
echo "=== Installing bundled applications ==="
brew update
brew bundle

echo "=== Installing ZSH ==="
export ZSH="$HOME/.dotfiles/oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme >"$ZSH/custom/themes/gruvbox.zsh-theme"

echo "=== iTerm Setup ==="
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.dotfiles/iTerm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
killall cfprefsd

echo "=== Installing ==="
mkdir -p "$HOME/.config"
ln -nfs "$HOME/.dotfiles/nvim" "$HOME/.config/nvim"

echo "=== Link config files ==="
for file in vimrc zshrc zshenv gitconfig ctags tmux.conf alacritty.yml; do
	if [ -f "$HOME/.$file" ]; then
		mv "$HOME/.$file" "$HOME/.$file.bkp"
	fi

	ln -nfs "$HOME/.dotfiles/$file" "$HOME/.$file"
done

echo "=== Installing Node ==="
if [ ! -f "$HOME/.nvm" ]; then
	mkdir "$HOME/.nvm"
fi

. "$HOME/.dotfiles/nvm.zsh"

# Installing Node
nvm install node
nvm use node
nvm alias default node

echo "=== Installing neovim dependencies ==="
# Installing neovim's dependencies
sudo gem install neovim
pip install --user pynvim
npm install -g neovim prettier typescript typescript-language-server eslint eslint_d markdownlint prettier-eslint

echo "=== Fetching Oh-My-Zsh custom plugins ==="
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

echo "=== Tmux ==="
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/scripts/install_plugins.sh

echo "=== Rust ==="
curl https://sh.rustup.rs -sSf | sh
