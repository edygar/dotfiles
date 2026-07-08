#!/usr/bin/env zsh
#
# install.zsh
#
# Dotfiles installation script for a fresh macOS machine.
# Run this after cloning the bare repo.
#
# Usage: ~/.local/bin/install.zsh

set -e

echo "=== Dotfiles Install ==="
echo ""

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "[1/7] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "[1/7] Homebrew already installed."
fi

# 2. Brewfile
echo "[2/7] Installing packages from Brewfile..."
brew bundle --file="$HOME/Brewfile" 2>&1 | tail -5

# 3. macOS defaults
echo "[3/7] Setting macOS defaults..."
"$HOME/.local/bin/macos-defaults.zsh" 2>&1

# 4. Unsplash API key
echo "[4/7] Unsplash API key..."
mkdir -p "$HOME/.config/wallpapers"
KEY_FILE="$HOME/.config/wallpapers/.unsplash-key"
if [[ -f "$KEY_FILE" ]] && [[ -s "$KEY_FILE" ]]; then
  echo "  API key already set."
else
  echo "  Get a free key at https://unsplash.com/developers"
  printf "  Enter your Unsplash API access key: "
  read -r api_key
  if [[ -n "$api_key" ]]; then
    echo "$api_key" > "$KEY_FILE"
    echo "  Key saved to $KEY_FILE"
  else
    echo "  Skipped (wallpaper rotation won't work without it)"
  fi
fi

# 5. Gitconfig (personal identity is tracked, but machine-specific overrides)
echo "[5/7] Git identity..."
if [[ ! -f "$HOME/.gitconfig.revolut" ]]; then
  printf "  Create .gitconfig.revolut? Enter work email (or press Enter to skip): "
  read -r work_email
  if [[ -n "$work_email" ]]; then
    cat > "$HOME/.gitconfig.revolut" <<EOF
[user]
    name = "Edygar de Lima Oliveira"
    email = "$work_email"
    username = edygar
EOF
    echo "  Created ~/.gitconfig.revolut"
  else
    echo "  Skipped."
  fi
else
  echo "  .gitconfig.revolut already exists."
fi

# 6. Cron jobs
echo "[6/7] Setting up cron jobs..."
CRON=""
if ! crontab -l 2>/dev/null | grep -q "wallpaper.zsh"; then
  CRON="${CRON}0 * * * * $HOME/.local/bin/wallpaper.zsh\n"
fi
if [[ -n "$CRON" ]]; then
  (crontab -l 2>/dev/null; echo "$CRON") | crontab -
  echo "  Added wallpaper rotation cron job."
else
  echo "  Cron jobs already set up."
fi

# 7. Initial wallpaper
echo "[7/7] Fetching initial wallpaper..."
if [[ -f "$KEY_FILE" ]] && [[ -s "$KEY_FILE" ]]; then
  "$HOME/.local/bin/wallpaper.zsh" init 2>&1
else
  echo "  Skipped (no API key)."
fi

echo ""
echo "=== Install complete! ==="
echo ""
echo "Manual steps remaining:"
echo "  - Restart kitty (fully quit, not just reload)"
echo "  - Run :Lazy sync in nvim"
echo "  - Grant accessibility permissions: System Settings > Privacy & Security"
echo "    - Mouseless"
echo "    - Homerow"
echo "    - AeroSpace"
echo "  - Configure Mouseless via GUI (mouseless://settings)"
echo "  - Import Homerow config: defaults import com.superultra.Homerow ~/.config/homerow/config.plist"
echo "  - Symlink Leader Key config: ln -sf ~/.config/leader-key/config.json '~/Library/Application Support/Leader Key/config.json'"
echo "  - Add Raycast script commands from ~/.local/bin/raycast-*.zsh"
echo "  - Rebuild neovim: ~/.local/bin/buildnvim.sh (if using local build)"
