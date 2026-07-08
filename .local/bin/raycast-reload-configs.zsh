#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reload Configs
# @raycast.description Reload kitty, aerospace, leader key, mouseless, sketchybar
# @raycast.icon 🔄
# @raycast.mode compact

killall -SIGUSR1 kitty 2>/dev/null
/opt/homebrew/bin/aerospace reload-config 2>/dev/null
killall -SIGUSR1 "Leader Key" 2>/dev/null
killall -SIGHUP mouseless 2>/dev/null
brew services restart felixkratz/formulae/sketchybar 2>/dev/null

echo "Configs reloaded"
