#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Homerow Chain Clicks
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖱️
# @raycast.packageName Homerow
# @raycast.argument1 { "type": "dropdown", "optional": true, "default": "toggle", "data": [{"title":"Toggle","value":"toggle"},{"title":"On","value":"on"},{"title":"Off","value":"off"}] }

APP_ID="com.superultra.Homerow"
KEY="chain-clicks"

ACTION="${1:-toggle}"

current=$(defaults read "$APP_ID" "$KEY" 2>/dev/null || echo 0)

case "$ACTION" in
  on)
    next=true
    ;;
  off)
    next=false
    ;;
  *)
    if [ "$current" = 1 ]; then
      next=false
    else
      next=true
    fi
    ;;
esac

defaults write "$APP_ID" "$KEY" -bool "$next"

echo "Chain clicks: $next"
