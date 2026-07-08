#!/bin/bash

# Volume item

sketchybar --add item volume right \
  --set volume \
  icon.font="$FONT:Regular:16.0" \
  icon.color=$WHITE \
  label.font="$FONT:Semibold:13.0" \
  label.color=$WHITE \
  script="$PLUGIN_DIR/volume.sh" \
  --subscribe volume volume_change
