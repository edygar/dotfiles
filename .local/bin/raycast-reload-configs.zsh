#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reload Configs
# @raycast.description Reload kitty, aerospace, hammerspoon, leader key, mouseless, sketchybar
# @raycast.icon 🔄
# @raycast.mode compact

killall -SIGUSR1 kitty 2>/dev/null
/opt/homebrew/bin/aerospace reload-config 2>/dev/null
killall mouseless 2>/dev/null; sleep 0.5; open -a Mouseless 2>/dev/null
brew services restart felixkratz/formulae/sketchybar 2>/dev/null
if pgrep -x Hammerspoon >/dev/null 2>&1; then
  /opt/homebrew/bin/hs -c 'hs.reload(); return "ok"' 2>/dev/null
else
  open -a Hammerspoon 2>/dev/null
fi
open -a "Leader Key" 2>/dev/null

echo "Configs reloaded"
