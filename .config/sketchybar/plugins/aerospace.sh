#!/bin/sh

# AeroSpace workspace change handler
# Only shows workspaces that have windows

WORKSPACE_NAME="$AEROSPACE_FOCUSED_WORKSPACE"
ACTIVE_COLOR="0xff659DDA"
INACTIVE_COLOR="0xff494d64"

# Get workspaces that have windows
POPULATED_WORKSPACES=$(/opt/homebrew/bin/aerospace list-workspaces --monitor all --empty no 2>/dev/null)

WORKSPACES="A B D F G M O P Q R S T U V X Y Z"

for ws in $WORKSPACES; do
  if echo "$POPULATED_WORKSPACES" | grep -q "^${ws}$"; then
    # Workspace has windows - show it
    if [ "$ws" = "$WORKSPACE_NAME" ]; then
      sketchybar --set space.$ws drawing=on icon.color=$ACTIVE_COLOR
    else
      sketchybar --set space.$ws drawing=on icon.color=$INACTIVE_COLOR
    fi
  else
    # Empty workspace - hide it
    sketchybar --set space.$ws drawing=off
  fi
done
