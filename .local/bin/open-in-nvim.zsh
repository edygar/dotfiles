#!/usr/bin/env zsh
#
# open-in-nvim.zsh
#
# Opens a file in the nearest running neovim instance via kitty remote control.
# If no nvim is running, opens a new kitty tab with nvim.
#
# Usage:
#   open-in-nvim.zsh <file>

FILE="$1"
if [[ -z "$FILE" ]]; then
  exit 1
fi

# Get absolute path
FILE=$(cd "$(dirname "$FILE")" 2>/dev/null && pwd)/$(basename "$FILE") || FILE="$1"

# Connect to kitty's remote control socket
export KITTY_LISTEN_ON="unix:/tmp/mykitty"

# Find kitty windows running nvim
KITTY_JSON=$(kitty @ ls 2>/dev/null)
if [[ -z "$KITTY_JSON" ]]; then
  # Kitty not running or no remote control - open new kitty with nvim
  open -a kitty --args nvim "$FILE"
  exit 0
fi

# Find the first window whose foreground process is nvim
NVIM_WIN=$(echo "$KITTY_JSON" | jq -r '
  [.[] | . as $tabset |
    .tabs[] | . as $tab |
      .windows[] | select(.foreground_processes[0].cmdline[0] // "" | test("nvim")) |
        {win: .id, tab: $tab.id, tabset: $tabset.id, title: .title}
  ] | .[0] // empty
' 2>/dev/null)

if [[ -n "$NVIM_WIN" ]]; then
  # Found a running nvim - send :e command to it
  WIN_ID=$(echo "$NVIM_WIN" | jq -r '.win')
  kitty @ focus-window --match "id:$WIN_ID" 2>/dev/null
  kitty @ send-text --match "id:$WIN_ID" ":e ${FILE}\r" 2>/dev/null
else
  # No nvim running - open a new kitty tab with nvim
  kitty @ launch --type=tab nvim "$FILE" 2>/dev/null
fi
