#!/bin/bash

sketchybar --add item volume right \
           --set volume icon.font="SauceCodePro Nerd Font:Regular:18.0" \
                       icon.color=$WHITE \
                       script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change 
