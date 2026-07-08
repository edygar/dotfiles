#!/bin/bash

# Update all workspace labels with their app icons
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
  else
    icon_strip=""
  fi
  
  if [ -z "$icon_strip" ] || [ "$icon_strip" = " " ]; then
    sketchybar --set space.$ws drawing=off
  else
    sketchybar --set space.$ws drawing=on label="$icon_strip"
  fi
done
