#!/bin/bash

# Battery item

sketchybar --add item battery right \
  --set battery \
  icon.font="$FONT:Regular:16.0" \
  icon.color=$WHITE \
  label.font="$FONT:Semibold:13.0" \
  label.color=$WHITE \
  update_freq=30 \
  script="$PLUGIN_DIR/battery.sh"
