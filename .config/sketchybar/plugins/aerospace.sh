#!/bin/sh

# AeroSpace workspace change handler

WORKSPACE_NAME="$AEROSPACE_FOCUSED_WORKSPACE"
ACTIVE_COLOR="0xff659DDA"
INACTIVE_COLOR="0xff494d64"

WORKSPACES="A B D F G M O P Q R S T U V X Y Z"

for ws in $WORKSPACES; do
  if [ "$ws" = "$WORKSPACE_NAME" ]; then
    sketchybar --set space.$ws icon.color=$ACTIVE_COLOR
  else
    sketchybar --set space.$ws icon.color=$INACTIVE_COLOR
  fi
done
