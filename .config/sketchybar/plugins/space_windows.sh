#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
AEROSPACE=/opt/homebrew/bin/aerospace

SPACE_SIDS="A S D F Z X V Q R T"

for ws in $SPACE_SIDS; do
  APPS=$($AEROSPACE list-windows --workspace $ws --format "%{app-name}%{newline}" 2>/dev/null)
  
  icon_strip=" "
  if [ -n "$APPS" ]; then
    while IFS= read -r app; do
      if [ -n "$app" ]; then
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      fi
    done <<< "$APPS"
  fi
  
  if [ -z "$icon_strip" ] || [ "$icon_strip" = " " ]; then
    # No windows - hide the space
    sketchybar --set space.$ws drawing=off 2>/dev/null
  else
    sketchybar --set space.$ws drawing=on label="$icon_strip" 2>/dev/null
  fi
done
