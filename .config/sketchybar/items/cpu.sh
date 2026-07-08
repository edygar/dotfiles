#!/bin/bash

sketchybar --add item cpu right \
           --set cpu  update_freq=2 \
                      icon=""  \
                      icon.font="SauceCodePro Nerd Font:Regular:16.0" \
                      icon.color=$WHITE \
                      script="$PLUGIN_DIR/cpu.sh"
