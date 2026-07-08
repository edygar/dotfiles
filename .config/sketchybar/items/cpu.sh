#!/bin/bash

sketchybar --add item cpu right \
           --set cpu  update_freq=2 \
                      icon=""  \
                      icon.color=$CPU_ICON_COLOR \
                      script="$PLUGIN_DIR/cpu.sh"
