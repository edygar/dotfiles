#!/bin/bash

# CPU item

sketchybar --add item cpu right \
  --set cpu \
  icon=$CPU_ICON \
  icon.color=$GREY \
  label.font="$FONT:Semibold:13.0" \
  label.color=$WHITE \
  update_freq=10 \
  script="$PLUGIN_DIR/cpu.sh"
