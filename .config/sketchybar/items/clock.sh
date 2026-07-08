#!/bin/bash

# Clock item

sketchybar --add item clock right \
  --set clock \
  icon=$CLOCK_ICON \
  icon.color=$GREY \
  label.font="$FONT:Semibold:13.0" \
  label.color=$WHITE \
  update_freq=5 \
  script="$PLUGIN_DIR/clock.sh"
