#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon="󰥔"  \
                          icon.font="SauceCodePro Nerd Font:Regular:16.0" \
                          icon.color=$WHITE \
                          update_freq=30 \
                          script="$PLUGIN_DIR/calendar.sh"
