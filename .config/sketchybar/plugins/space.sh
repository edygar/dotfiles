#!/bin/sh

source "$CONFIG_DIR/colors.sh"

AEROSPACE=/opt/homebrew/bin/aerospace
FOCUSED=$($AEROSPACE list-workspaces --focused 2>/dev/null)

WORKSPACES="A B D F G M O P Q R S T U V X Y Z"

for ws in $WORKSPACES; do
  if [ "$ws" = "$FOCUSED" ]; then
    sketchybar --set space.$ws background.drawing=on \
                           background.color=$ACCENT_COLOR \
                           icon.color=$BAR_COLOR
  else
    sketchybar --set space.$ws background.drawing=off \
                           icon.color=$BAR_COLOR
  fi
done
