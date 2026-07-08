#!/usr/bin/env zsh
#
# workspace-wallpaper.zsh
#
# Sets a consistent wallpaper per aerospace workspace.
# Each workspace remembers its wallpaper until explicitly changed
# via next/previous wallpaper scripts.
#
# Usage:
#   workspace-wallpaper.zsh <workspace-name>
#
# Add to aerospace.toml:
#   exec-on-workspace-change = ['/bin/zsh', '-c', '~/.local/bin/workspace-wallpaper.zsh $AEROSPACE_FOCUSED_WORKSPACE']

WALLPAPER_DIR="$HOME/.config/wallpapers"
WORKSPACE_MAP="$WALLPAPER_DIR/.workspace-map"
KEY_FILE="$WALLPAPER_DIR/.unsplash-key"

workspace="${1:-}"
if [[ -z "$workspace" ]]; then
  echo "Usage: $0 <workspace-name>"
  exit 1
fi

mkdir -p "$WALLPAPER_DIR"

# Read the workspace-to-wallpaper map
get_wallpaper_for_workspace() {
  local ws="$1"
  if [[ -f "$WORKSPACE_MAP" ]]; then
    grep "^${ws}=" "$WORKSPACE_MAP" 2>/dev/null | cut -d'=' -f2-
  fi
}

set_wallpaper_for_workspace() {
  local ws="$1"
  local wallpaper="$2"
  # Remove existing entry, add new one
  if [[ -f "$WORKSPACE_MAP" ]]; then
    grep -v "^${ws}=" "$WORKSPACE_MAP" > "$WORKSPACE_MAP.tmp" 2>/dev/null
    mv "$WORKSPACE_MAP.tmp" "$WORKSPACE_MAP"
  fi
  echo "${ws}=${wallpaper}" >> "$WORKSPACE_MAP"
}

# Check if this workspace already has a wallpaper assigned
existing=$(get_wallpaper_for_workspace "$workspace")

if [[ -n "$existing" ]] && [[ -f "$existing" ]] && file "$existing" | grep -q "JPEG"; then
  # Use the remembered wallpaper
  wallpaper set "$existing"
  exit 0
fi

# No wallpaper assigned yet, pick one from the pool
files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
count=${#files}

if [[ $count -eq 0 ]]; then
  # No wallpapers in pool, try to fetch one
  if [[ -f "$KEY_FILE" ]] && [[ -s "$KEY_FILE" ]]; then
    "$HOME/.local/bin/wallpaper.zsh" >/dev/null 2>&1
    files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
    count=${#files}
  fi
fi

if [[ $count -eq 0 ]]; then
  exit 1
fi

# Pick the most recently downloaded wallpaper
wallpaper_file="${files[$count]}"
set_wallpaper_for_workspace "$workspace" "$wallpaper_file"
wallpaper set "$wallpaper_file"
