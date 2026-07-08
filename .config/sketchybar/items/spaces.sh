#!/bin/bash

SPACE_SIDS=(A S D F Z X V Q R T)

# Register the aerospace workspace change event
sketchybar --add event aerospace_workspace_change

for sid in "${SPACE_SIDS[@]}"
do
  sketchybar --add item space.$sid left                                 \
             --set space.$sid                                           \
                              icon=$sid                                  \
                              icon.font="SauceCodePro Nerd Font:Bold:16.0" \
                              icon.color=$BAR_COLOR                   \
                              label.font="sketchybar-app-font:Regular:17.0" \
                              label.padding_right=20                     \
                              label.y_offset=-1                          \
                              script="$PLUGIN_DIR/space.sh"              \
                              click_script="/opt/homebrew/bin/aerospace workspace $sid"
  sketchybar --subscribe space.$sid aerospace_workspace_change
done

sketchybar --add item space_separator left                             \
           --set space_separator icon=""                                \
                                 icon.color=$BAR_COLOR                \
                                 icon.padding_left=4                    \
                                 label.drawing=off                      \
                                 background.drawing=off                 \
                                 script="$PLUGIN_DIR/space_windows.sh"
