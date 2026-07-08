#!/bin/sh

VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

if [ "$MUTED" = "true" ]; then
  ICON=$VOLUME_0
elif [ "$VOLUME" -gt 66 ]; then
  ICON=$VOLUME_100
elif [ "$VOLUME" -gt 33 ]; then
  ICON=$VOLUME_66
else
  ICON=$VOLUME_33
fi

sketchybar --set volume icon="$ICON" label="${VOLUME}%"
