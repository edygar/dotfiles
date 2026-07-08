#!/bin/sh

BATTERY_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
BATTERY_CHARGING=$(pmset -g batt | grep -q "AC Power" && echo "true" || echo "false")

if [ "$BATTERY_CHARGING" = "true" ]; then
  ICON=$BATTERY_CHARGING
elif [ "$BATTERY_PERCENT" -gt 75 ]; then
  ICON=$BATTERY_100
elif [ "$BATTERY_PERCENT" -gt 50 ]; then
  ICON=$BATTERY_75
elif [ "$BATTERY_PERCENT" -gt 25 ]; then
  ICON=$BATTERY_50
else
  ICON=$BATTERY_25
fi

sketchybar --set battery icon="$ICON" label="${BATTERY_PERCENT}%"
