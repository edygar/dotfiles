#!/bin/bash

# Front app - shows current focused app name and icon

sketchybar --add item front_app left \
  --set front_app \
  icon=$FRONT_APP_ICON \
  icon.color=$BLUE \
  label.font="$FONT:Semibold:13.0" \
  label.color=$WHITE \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
