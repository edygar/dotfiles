#!/bin/sh

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

FOCUSED="${AEROSPACE_FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"

WORKSPACES="A S D F Z X V Q R T"

CMD=""
for ws in $WORKSPACES; do
  if [ "$ws" = "$FOCUSED" ]; then
    CMD="--set space.$ws background.drawing=on background.color=$ACCENT_COLOR icon.color=$BAR_COLOR $CMD"
  else
    CMD="--set space.$ws background.drawing=off icon.color=$BAR_COLOR $CMD"
  fi
done

sketchybar $CMD 2>/dev/null
