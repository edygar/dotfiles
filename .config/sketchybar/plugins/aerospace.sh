#!/bin/bash

# AeroSpace workspace + windows accordion for sketchybar
# Shows busy workspaces, expands focused workspace with app icons
# Highlights the focused app's icon

source "$CONFIG_DIR/colors.sh"

ACTIVE_COLOR=$BLUE
INACTIVE_COLOR=$GREY
FOCUSED_APP_COLOR=$BLUE
APP_ICON_COLOR=$WHITE
APP_ICON_DIMMED=$GREY

WORKSPACE_NAME="$AEROSPACE_FOCUSED_WORKSPACE"
AEROSPACE=/opt/homebrew/bin/aerospace

# Get all windows with workspace, app name, and focus state
WINDOWS=$($AEROSPACE list-windows --all --format "%{workspace}|%{app-name}|%{window-title}%{newline}" 2>/dev/null)

# Get the focused window's app name
FOCUSED_APP=$($AEROSPACE list-windows --focused --format "%{app-name}" 2>/dev/null | head -1)

# Get unique busy workspaces
BUSY_WORKSPACES=$(echo "$WINDOWS" | cut -d'|' -f1 | awk 'NF && !seen[$0]++' | sort -u)

ALL_WORKSPACES="A B D F G M O P Q R S T U V X Y Z"

for ws in $ALL_WORKSPACES; do
  IS_BUSY=$(echo "$BUSY_WORKSPACES" | grep -q "^${ws}$" && echo "yes" || echo "no")
  IS_FOCUSED=$([ "$ws" = "$WORKSPACE_NAME" ] && echo "yes" || echo "no")

  if [ "$IS_BUSY" = "no" ]; then
    sketchybar --set space.$ws drawing=off 2>/dev/null
    sketchybar --remove "/space.$ws\.app\./" 2>/dev/null
    continue
  fi

  # Show workspace letter
  if [ "$IS_FOCUSED" = "yes" ]; then
    sketchybar --set space.$ws drawing=on icon.color=$ACTIVE_COLOR 2>/dev/null
  else
    sketchybar --set space.$ws drawing=on icon.color=$INACTIVE_COLOR 2>/dev/null
  fi

  if [ "$IS_FOCUSED" = "yes" ]; then
    # Remove old app items
    sketchybar --remove "/space.$ws\.app\./" 2>/dev/null

    # Add app icons for the focused workspace
    APPS=$(echo "$WINDOWS" | grep "^${ws}|" | cut -d'|' -f2 | awk 'NF')
    APP_INDEX=0
    for app in $APPS; do
      ITEM_NAME="space.${ws}.app.${APP_INDEX}"
      if [ "$app" = "$FOCUSED_APP" ]; then
        COLOR=$FOCUSED_APP_COLOR
      else
        COLOR=$APP_ICON_DIMMED
      fi
      sketchybar --add item $ITEM_NAME left \
        --set $ITEM_NAME \
        icon.background.image="app.$app" \
        icon.background.color=$BG080 \
        icon.padding_left=3 \
        icon.padding_right=3 \
        label.drawing=off \
        icon.color=$COLOR \
        2>/dev/null
      APP_INDEX=$((APP_INDEX + 1))
    done
  else
    # Collapsed - remove app icons
    sketchybar --remove "/space.$ws\.app\./" 2>/dev/null
  fi
done
