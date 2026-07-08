#!/bin/bash

sketchybar --add item volume right \
           --set volume icon.color=$VOLUME_ICON_COLOR \
                       script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change 
