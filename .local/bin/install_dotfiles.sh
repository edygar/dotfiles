#!/usr/bin/env zsh
#
# install_dotfiles.sh
#
# Dotfiles installation script for a fresh macOS machine.
# Run this after cloning the bare repo.
#
# Usage: ~/.local/bin/install_dotfiles.sh

set -e

echo "=== Dotfiles Install ==="
echo ""

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "[1/9] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "[1/9] Homebrew already installed."
fi

# 2. Brewfile
echo "[2/9] Installing packages from Brewfile..."
brew bundle --file="$HOME/.config/homebrew/Brewfile" 2>&1 | tail -5

# 3. macOS defaults
echo "[3/9] Setting macOS defaults..."
"$HOME/.local/bin/macos-defaults.zsh" 2>&1

# 4. Unsplash API key
echo "[4/9] Unsplash API key..."
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
echo "[5/9] Git identity..."
if [[ ! -f "$HOME/.gitconfig.work" ]]; then
  printf "  Create .gitconfig.work? Enter work email (or press Enter to skip): "
  read -r work_email
  if [[ -n "$work_email" ]]; then
    cat > "$HOME/.gitconfig.work" <<EOF
[user]
    name = "Edygar de Lima Oliveira"
    email = "$work_email"
    username = edygar
EOF
    echo "  Created ~/.gitconfig.work"
  else
    echo "  Skipped."
  fi
else
  echo "  .gitconfig.work already exists."
fi

# 6. Leader Key config symlink
echo "[6/9] Leader Key config symlink..."
LEADER_KEY_DIR="$HOME/Library/Application Support/Leader Key"
mkdir -p "$LEADER_KEY_DIR"
if [[ -L "$LEADER_KEY_DIR/config.json" ]]; then
  echo "  Symlink already exists."
else
  ln -sf "$HOME/.config/leader-key/config.json" "$LEADER_KEY_DIR/config.json"
  echo "  Created symlink."
fi

# 7. Homerow config import
echo "[7/10] Homerow config import..."
if defaults read com.superultra.Homerow 2>/dev/null | grep -q "search-shortcut"; then
  echo "  Homerow config already imported."
else
  defaults import com.superultra.Homerow "$HOME/.config/homerow/config.plist" 2>/dev/null && echo "  Imported." || echo "  Skipped (Homerow not installed yet)."
fi

# 8. Default app for code files
echo "[8/10] Setting Neovim as default for code files..."
APP_ID="com.edygar.neovim"
EXTENSIONS="js jsx ts tsx json yaml yml toml md markdown lua py rs go c h cpp hpp java kt swift sh zsh bash sql html css scss sass less xml svg vue svelte graphql gql dockerfile makefile cmake gradle gitconfig gitignore env vim diff patch txt log conf cfg ini properties tf hcl nix"
if command -v duti >/dev/null 2>&1; then
  for ext in $EXTENSIONS; do
    duti -s $APP_ID .$ext all 2>/dev/null
  done
  echo "  Done."
else
  echo "  Skipped (duti not installed)."
fi

# 9. Cron jobs
echo "[9/10] Setting up cron jobs..."
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

# 10. Initial wallpaper
echo "[10/10] Fetching initial wallpaper..."
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
echo "  - Add Raycast script commands from ~/.local/bin/raycast-*.zsh"
echo "  - Rebuild neovim: ~/.local/bin/buildnvim.sh (if using local build)"
