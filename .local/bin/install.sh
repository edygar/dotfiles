#!/usr/bin/env zsh
#
# install.sh
#
# One-shot setup/refresh script for macOS dotfiles.
# On a fresh machine: clones the bare repo, checks out files, and installs everything.
# On an existing machine: refreshes packages, settings, and configurations.
#
# Usage (fresh machine):
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/edygar/dotfiles/main/.local/bin/install.sh)"
#
# Usage (existing machine):
#   ~/.local/bin/install.sh

set -e

REPO_URL="git@github.com:edygar/dotfiles.git"
REPO_DIR="$HOME/Code/personal/dotfiles"

echo "=== Dotfiles Setup ==="
echo ""

# ─── 1. Clone (fresh machine) or verify (existing) ───────────────────────────

if [[ ! -d "$REPO_DIR" ]]; then
  echo "[1/12] Cloning bare repo..."
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone --bare "$REPO_URL" "$REPO_DIR"

  # Backup any existing files that would conflict
  BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%s)"
  CONFLICTS=$(git --git-dir="$REPO_DIR" --work-tree="$HOME" checkout 2>&1 | grep -oE '\S+' | head -20)
  if [[ -n "$CONFLICTS" ]]; then
    echo "  Backing up conflicting files to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    echo "$CONFLICTS" | while read -r f; do
      if [[ -f "$HOME/$f" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$f")"
        mv "$HOME/$f" "$BACKUP_DIR/$f"
      fi
    done
  fi
  git --git-dir="$REPO_DIR" --work-tree="$HOME" checkout 2>/dev/null || true
  git --git-dir="$REPO_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no
  echo "  Repository cloned and files checked out."
  if [[ -n "$CONFLICTS" ]]; then
    echo "  Conflicting files backed up to $BACKUP_DIR"
  fi
else
  echo "[1/12] Repository already exists, pulling latest..."
  git --git-dir="$REPO_DIR" --work-tree="$HOME" pull --rebase 2>/dev/null || true
fi

# ─── 2. Homebrew ──────────────────────────────────────────────────────────────

if ! command -v brew >/dev/null 2>&1; then
  echo "[2/12] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "[2/12] Homebrew already installed."
fi

# ─── 3. Brewfile ──────────────────────────────────────────────────────────────

echo "[3/12] Installing packages from Brewfile..."
brew bundle --file="$HOME/.config/homebrew/Brewfile" 2>&1 | tail -5

# ─── 4. macOS defaults ────────────────────────────────────────────────────────

echo "[4/12] Setting macOS defaults..."
"$HOME/.local/bin/macos-defaults.zsh" 2>&1

# ─── 5. Unsplash API key ─────────────────────────────────────────────────────

echo "[5/12] Unsplash API key..."
mkdir -p "$HOME/.config/wallpapers"
KEY_FILE="$HOME/.config/wallpapers/.unsplash-key"
if [[ -f "$KEY_FILE" ]] && [[ -s "$KEY_FILE" ]]; then
  echo "  API key already set."
else
  echo "  Get a free key at https://unsplash.com/developers"
  printf "  Enter your Unsplash API access key (or press Enter to skip): "
  read -r api_key
  if [[ -n "$api_key" ]]; then
    echo "$api_key" > "$KEY_FILE"
    echo "  Key saved."
  else
    echo "  Skipped (wallpaper rotation won't work without it)."
  fi
fi

# ─── 6. Git work identity ────────────────────────────────────────────────────

echo "[6/12] Git work identity..."
WORK_GITCONFIG="$HOME/.gitconfig.work"
if [[ -f "$WORK_GITCONFIG" ]]; then
  echo "  Work identity already exists."
else
  printf "  Create work git identity? Enter work email (or press Enter to skip): "
  read -r work_email
  if [[ -n "$work_email" ]]; then
    cat > "$WORK_GITCONFIG" <<EOF
[user]
    name = "Edygar de Lima Oliveira"
    email = "$work_email"
    username = edygar
EOF
    echo "  Created ~/.gitconfig.work"
  else
    echo "  Skipped."
  fi
fi

# ─── 7. Leader Key config symlink ────────────────────────────────────────────

echo "[7/12] Leader Key config symlink..."
LEADER_KEY_DIR="$HOME/Library/Application Support/Leader Key"
mkdir -p "$LEADER_KEY_DIR"
if [[ -L "$LEADER_KEY_DIR/config.json" ]]; then
  echo "  Symlink already exists."
else
  ln -sf "$HOME/.config/leader-key/config.json" "$LEADER_KEY_DIR/config.json"
  echo "  Created symlink."
fi

# ─── 8. Raycast extension symlink ─────────────────────────────────────────────

echo "[8/12] Raycast extension symlink..."
RAYCAST_EXT_DIR="$HOME/.config/raycast-x/extensions"
RAYCAST_EXT_SRC="$HOME/.config/raycast-x/kitty-manager"
if [[ -d "$RAYCAST_EXT_SRC" ]]; then
  mkdir -p "$RAYCAST_EXT_DIR"
  if [[ -L "$RAYCAST_EXT_DIR/kitty-manager" ]]; then
    echo "  Symlink already exists."
  else
    ln -sf ../kitty-manager "$RAYCAST_EXT_DIR/kitty-manager"
    echo "  Created symlink."
  fi
else
  echo "  Skipped (kitty-manager extension not found)."
fi

# ─── 8b. Build Kitty Raycast extension ───────────────────────────────────────

echo "[8b/12] Building Kitty Raycast extension..."
KITTY_EXT_DIR="$HOME/.config/raycast-x/extensions/kitty"
if [[ -f "$KITTY_EXT_DIR/install.sh" ]]; then
  "$KITTY_EXT_DIR/install.sh"
else
  echo "  Skipped (kitty extension not found)."
fi

# ─── 9. Homerow config import ────────────────────────────────────────────────

echo "[9/12] Homerow config..."
if defaults read com.superultra.Homerow 2>/dev/null | grep -q "search-shortcut"; then
  echo "  Config already imported."
else
  defaults import com.superultra.Homerow "$HOME/.config/homerow/config.plist" 2>/dev/null && echo "  Imported." || echo "  Skipped (Homerow not installed yet)."
fi

# ─── 9. Default app for code files ───────────────────────────────────────────

echo "[10/12] Setting Neovim as default for code files..."
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

# ─── 10. Cron jobs + initial wallpaper ───────────────────────────────────────

echo "[11/12] Cron jobs and wallpaper..."
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

if [[ -f "$KEY_FILE" ]] && [[ -s "$KEY_FILE" ]]; then
  if [[ $(ls "$HOME/.config/wallpapers/"wallpaper_*.* 2>/dev/null | wc -l) -eq 0 ]]; then
    echo "  Fetching initial wallpapers..."
    "$HOME/.local/bin/wallpaper.zsh" init 2>&1
  else
    echo "  Wallpapers already downloaded."
  fi
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Manual steps (if fresh install):"
echo "  - Restart kitty (fully quit, not just reload)"
echo "  - Run :Lazy sync in nvim"
echo "  - Grant accessibility permissions: System Settings > Privacy & Security"
echo "    - Mouseless, Homerow, AeroSpace"
echo "  - Configure Mouseless via GUI (mouseless://settings)"
echo "  - Add Raycast script commands from ~/.local/bin/raycast-*.zsh"
echo "  - Rebuild neovim: ~/.local/bin/buildnvim.sh (if using local build)"
echo "  - Install SF Pro font: brew install --cask font-sf-pro (requires sudo)"
echo ""
echo "To refresh an existing setup, just re-run:"
echo "  ~/.local/bin/install.sh"
