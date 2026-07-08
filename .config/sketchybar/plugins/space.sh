#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Extract workspace name from item name (space.A -> A)
WS_NAME=$(echo "$NAME" | sed 's/space\.//')

# Get focused workspace from aerospace
FOCUSED=$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)

if [ "$WS_NAME" = "$FOCUSED" ]; then
  sketchybar --set $NAME background.drawing=on \
                         background.color=$ACCENT_COLOR \
                         icon.color=$BAR_COLOR
else
  sketchybar --set $NAME background.drawing=off \
                         icon.color=$BAR_COLOR
fi
