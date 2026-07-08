#!/bin/sh

BATTERY_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
BATTERY_CHARGING=$(pmset -g batt | grep -q "AC Power" && echo "true" || echo "false")

ICON="󰁺"
if [ "$BATTERY_CHARGING" = "true" ]; then
  ICON="󰂅"
elif [ "$BATTERY_PERCENT" -gt 80 ]; then
  ICON="󰁹"
elif [ "$BATTERY_PERCENT" -gt 60 ]; then
  ICON="󰁸"
elif [ "$BATTERY_PERCENT" -gt 40 ]; then
  ICON="󰁷"
elif [ "$BATTERY_PERCENT" -gt 20 ]; then
  ICON="󰁶"
fi

sketchybar --set battery icon="$ICON" label="${BATTERY_PERCENT}%"
