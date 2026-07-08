#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=""  \
                          icon.color=$CALENDAR_ICON_COLOR \
                          update_freq=30 \
                          script="$PLUGIN_DIR/calendar.sh"
