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

# Link configuration files from the dotfiles directory
echo "Linking configurations..."
mkdir -p "$HOME/.config"
ln -sf "$HOME/.dotfiles/kitty.conf" "$HOME/.config/kitty/kitty.conf"
ln -sf "$HOME/.dotfiles/nvim" "$HOME/.config/"
curl https://raw.githubusercontent.com/knubie/vim-kitty-navigator/master/pass_keys.py > "$HOME/.config/kitty/pass_keys.py"
curl https://raw.githubusercontent.com/knubie/vim-kitty-navigator/master/neighboring_window.py > "$HOME/.config/kitty/neighboring_window.py"
chmod +x $HOME/.config/kitty/{pass_keys,neighboring_window}.py

for file in "$HOME"/.dotfiles/.*; do
  if [[ -f "$file" && "$(basename "$file")" != ".git" && "$(basename "$file")" != ".gitignore" ]]; then
    ln -sf "$file" "$HOME/$(basename "$file")"
  fi
done

echo "Installation complete."
