#!/usr/bin/env zsh

# Define the path to the Brewfile
brewfile="$HOME/.dotfiles/Brewfile"

# Check if Homebrew is installed, and if not, install it
if ! command -v brew >/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew found. Updating and upgrading packages..."
  brew update
  brew upgrade
fi

# Make sure Brewfile exists
if [ ! -f "$brewfile" ]; then
  echo "Brewfile not found at $brewfile."
  exit 1
fi

# Install packages from the Brewfile
echo "Installing packages..."
brew bundle --file="$brewfile"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

# Link configuration files from the dotfiles directory
echo "Linking configurations..."
mkdir -p "$HOME/.config/kitty"
ln -sf "$HOME/.dotfiles/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "$HOME/.dotfiles/kitty/macos-launch-services-cmdline" "$HOME/.config/kitty/"
ln -sf "$HOME/.dotfiles/nvim" "$HOME/.config/"
curl https://raw.githubusercontent.com/knubie/vim-kitty-navigator/master/pass_keys.py > "$HOME/.config/kitty/pass_keys.py"
curl https://raw.githubusercontent.com/knubie/vim-kitty-navigator/master/neighboring_window.py > "$HOME/.config/kitty/neighboring_window.py"
chmod +x $HOME/.config/kitty/{pass_keys,neighboring_window}.py

for file in "$HOME"/.dotfiles/.*; do
  if [[ -f "$file" && "$(basename "$file")" != ".git" && "$(basename "$file")" != ".gitignore" ]]; then
    ln -sf "$file" "$HOME/$(basename "$file")"
  fi
done


echo "Installing dependencies..."
volta install node
cargo install sccache exa bat ripgrep fd-find
npm install -g typescript prettier prettier_d_slim eslint_d eslint neovim typescript-language-server emmet-ls

echo "Installation complete."
