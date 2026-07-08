#!/bin/bash

SPACE_SIDS=(A B D F G M O P Q R S T U V X Y Z)

for sid in "${SPACE_SIDS[@]}"
do
  sketchybar --add item space.$sid left                                 \
             --set space.$sid                                           \
                              icon=$sid                                  \
                              icon.font="SF Pro:Heavy:18.0"           \
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
