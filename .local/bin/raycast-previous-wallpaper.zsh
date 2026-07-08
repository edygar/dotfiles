#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Previous Wallpaper
# @raycast.description Switch to the previous wallpaper and update current workspace
# @raycast.icon 🏙️
# @raycast.mode silent

WALLPAPER_DIR="$HOME/.config/wallpapers"
WORKSPACE_MAP="$WALLPAPER_DIR/.workspace-map"
STATE_FILE="$WALLPAPER_DIR/.current"

files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
count=${#files}

if [[ $count -eq 0 ]]; then
  echo "No wallpapers found"
  exit 1
fi

current=1
if [[ -f "$STATE_FILE" ]]; then
  current=$(cat "$STATE_FILE")
  current=$(( current - 1 ))
  if [[ $current -lt 1 ]]; then
    current=$count
  fi
fi

echo "$current" > "$STATE_FILE"
wallpaper="${files[$current]}"
wallpaper set "$wallpaper"

# Update current workspace mapping
ws=$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)
if [[ -n "$ws" ]] && [[ -f "$WORKSPACE_MAP" ]]; then
  grep -v "^${ws}=" "$WORKSPACE_MAP" > "$WORKSPACE_MAP.tmp" 2>/dev/null
  mv "$WORKSPACE_MAP.tmp" "$WORKSPACE_MAP"
  echo "${ws}=${wallpaper}" >> "$WORKSPACE_MAP"
fi
