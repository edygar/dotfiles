#!/usr/bin/env zsh
#
# bootstrap.sh
#
# One-shot setup script for a fresh macOS machine.
# Clones the bare dotfiles repo and runs the install script.
#
# Usage:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/edygar/dotfiles/main/.local/bin/bootstrap.sh)"

set -e

REPO_URL="git@github.com:edygar/dotfiles.git"
REPO_DIR="$HOME/Code/personal/dotfiles"

echo "=== Dotfiles Bootstrap ==="
echo ""

# Check if repo already exists
if [[ -d "$REPO_DIR" ]]; then
  echo "Repository already exists at $REPO_DIR"
else
  echo "Cloning bare repo to $REPO_DIR..."
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone --bare "$REPO_URL" "$REPO_DIR"
fi

# Set up the dotfiles alias
alias dotfiles="git --git-dir=$REPO_DIR --work-tree=$HOME"

# Checkout files (ignore untracked files error)
echo "Checking out dotfiles..."
git --git-dir="$REPO_DIR" --work-tree="$HOME" checkout 2>/dev/null || true
git --git-dir="$REPO_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no

# Run the install script
echo ""
if [[ -f "$HOME/.local/bin/install_dotfiles.sh" ]]; then
  chmod +x "$HOME/.local/bin/install_dotfiles.sh"
  "$HOME/.local/bin/install_dotfiles.sh"
else
  echo "Install script not found. Something went wrong with checkout."
  exit 1
fi
