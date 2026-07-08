#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ "$AEROSPACE_FOCUSED_WORKSPACE" = "$SPACE_NAME" ]; then
  sketchybar --set $NAME background.drawing=on \
                         background.color=$ACCENT_COLOR \
                         icon.color=$BAR_COLOR
else
  sketchybar --set $NAME background.drawing=off \
                         icon.color=$BAR_COLOR
fi
