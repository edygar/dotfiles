#!/usr/bin/env zsh
#
# workspace-wallpaper.zsh
#
# Sets a specific wallpaper when switching aerospace workspaces.
# Uses a hash of the workspace name to pick from cached wallpapers.
# If no wallpapers are cached, fetches a new one from Unsplash.
#
# Usage:
#   workspace-wallpaper.zsh <workspace-name>
#
# Add to aerospace.toml:
#   on-workspace-changed = ['exec-and-forget ~/.local/bin/workspace-wallpaper.zsh ${AEROSPACE_WORKSPACE}']

WALLPAPER_DIR="$HOME/.config/wallpapers"
STATE_FILE="$WALLPAPER_DIR/.workspace-wallpaper"
KEY_FILE="$WALLPAPER_DIR/.unsplash-key"
DEFAULT_QUERY="dark city skyline night"

workspace="${1:-}"
if [[ -z "$workspace" ]]; then
  echo "Usage: $0 <workspace-name>"
  exit 1
fi

mkdir -p "$WALLPAPER_DIR"

# Map each workspace to a specific wallpaper index
# Using a simple hash to distribute workspaces across cached wallpapers
case "$workspace" in
  A) index=1 ;;
  B) index=2 ;;
  D) index=3 ;;
  F) index=4 ;;
  G) index=5 ;;
  M) index=6 ;;
  O) index=7 ;;
  P) index=8 ;;
  Q) index=9 ;;
  R) index=10 ;;
  S) index=11 ;;
  T) index=12 ;;
  U) index=13 ;;
  V) index=14 ;;
  X) index=15 ;;
  Y) index=16 ;;
  Z) index=17 ;;
  *) index=1 ;;
esac

# Check if we have a dedicated wallpaper for this workspace
dedicated="$WALLPAPER_DIR/workspace_${workspace}.jpg"
if [[ -f "$dedicated" ]] && file "$dedicated" | grep -q "JPEG"; then
  wallpaper set "$dedicated"
  exit 0
fi

# Otherwise use the shared pool, indexed by workspace
files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
count=${#files}

if [[ $count -eq 0 ]]; then
  # No wallpapers yet, try to fetch one
  if [[ -f "$KEY_FILE" ]] && [[ -s "$KEY_FILE" ]]; then
    "$HOME/.local/bin/wallpaper.zsh" "$DEFAULT_QUERY" >/dev/null 2>&1
    files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
    count=${#files}
  fi
fi

if [[ $count -eq 0 ]]; then
  exit 1
fi

# Pick wallpaper by index (wrap around if needed)
local_index=$(( (index - 1) % count + 1 ))
wallpaper set "${files[$local_index]}"
