#!/bin/bash

sketchybar --add item battery right \
           --set battery icon.font="SauceCodePro Nerd Font:Regular:18.0" \
                         icon.color=$WHITE \
                         update_freq=120 \
                         script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
