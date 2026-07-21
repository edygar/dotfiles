#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reload Configs
# @raycast.description Reload kitty, aerospace, hammerspoon, leader key, mouseless, sketchybar
# @raycast.icon 🔄
# @raycast.mode compact
kitty @ load-config
/opt/homebrew/bin/aerospace reload-config 2>/dev/null
killall mouseless 2>/dev/null; sleep 0.5; open -a Mouseless 2>/dev/null
brew services restart felixkratz/formulae/sketchybar 2>/dev/null
leader_key_dir="$HOME/Library/Application Support/Leader Key"
leader_key_config="$leader_key_dir/config.json"
mkdir -p "$leader_key_dir"
ln -sfn "$HOME/.config/leader-key/icons/apps" "/Users/Shared/leader-key-icons"
if [[ ! -L "$leader_key_config" ]]; then
  ln -sf "$HOME/.config/leader-key/config.json" "$leader_key_config"
fi
if pgrep -x Hammerspoon >/dev/null 2>&1; then
  /opt/homebrew/bin/hs -c 'hs.reload(); return "ok"' 2>/dev/null
else
  open -a Hammerspoon 2>/dev/null
fi
open "leaderkey://config-reload" 2>/dev/null || open -a "Leader Key" 2>/dev/null

echo "Configs reloaded"
