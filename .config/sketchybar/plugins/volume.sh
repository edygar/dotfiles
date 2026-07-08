#!/bin/sh

VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

if [ "$MUTED" = "true" ]; then
  ICON="󰖁"
else
  ICON="󰕾"
fi

sketchybar --set volume icon="$ICON" label="${VOLUME}%"
