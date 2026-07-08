#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Launch App and Shortcut
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "App name (e.g. Google Chrome)" }
# @raycast.argument2 { "type": "text", "placeholder": "Shortcut (e.g. cmd shift a)" }
APP_NAME="$1"
SHORTCUT="$2"

# --- Parse modifiers and key ---
KEY=$(echo "$SHORTCUT" | awk '{print $NF}')
MODIFIERS=$(echo "$SHORTCUT" | awk '{$NF=""; print $0}' | xargs)

MOD_LIST=""
for mod in $MODIFIERS; do
  case "$mod" in
    cmd|command) MOD_LIST="$MOD_LIST, command down" ;;
    shift)       MOD_LIST="$MOD_LIST, shift down" ;;
    ctrl|control)MOD_LIST="$MOD_LIST, control down" ;;
    alt|option)  MOD_LIST="$MOD_LIST, option down" ;;
  esac
done
MOD_LIST=$(echo "$MOD_LIST" | sed 's/^, //')

# --- Try to get first window id and focus it ---
FIRST_ID=""
if command -v aerospace >/dev/null 2>&1; then
  FIRST_ID=$(aerospace list-windows --all --format '%{window-id} %{app-name}' \
    | awk -v app="$APP_NAME" 'BEGIN{IGNORECASE=1} $2==app {print $1; exit}')
  [ -n "$FIRST_ID" ] && aerospace focus --window-id "$FIRST_ID" >/dev/null 2>&1
fi

# --- If no window id was found, just open the app (no verification) ---
if [ -z "$FIRST_ID" ]; then
  open -a "$APP_NAME"
fi

# --- Send the keystroke ---
osascript <<EOF
tell application "System Events"
  keystroke "$KEY" using { $MOD_LIST }
end tell
EOF
