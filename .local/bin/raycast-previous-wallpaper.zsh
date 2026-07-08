#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Previous Wallpaper
# @raycast.description Switch to the previous wallpaper
# @raycast.icon 🏙️
# @raycast.mode silent

WALLPAPER_DIR="$HOME/.config/wallpapers"
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
wallpaper set "${files[$current]}"
