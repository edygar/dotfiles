#!/bin/sh

if [ -n "$INFO" ]; then
  sketchybar --set front_app label="$INFO"
else
  APP=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)
  sketchybar --set front_app label="${APP:-Unknown}"
fi
