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

# Find kitty remote control socket running nvim
KITTY_SOCKETS=( /tmp/kitty-socket-*(N) )

NVIM_SOCKET=""
NVIM_WIN=""
ALIVE_SOCKET=""

for SOCKET in "${KITTY_SOCKETS[@]}"; do
  export KITTY_LISTEN_ON="unix:$SOCKET"
  KITTY_JSON=$(kitty @ ls 2>/dev/null) || continue
  ALIVE_SOCKET="$SOCKET"
  NVIM_WIN=$(echo "$KITTY_JSON" | jq -r '
    [.[] | . as $tabset |
      .tabs[] | . as $tab |
        .windows[] | select(.foreground_processes[0].cmdline[0] // "" | test("nvim")) |
          {win: .id, tab: $tab.id, tabset: $tabset.id, title: .title}
    ] | .[0] // empty
  ' 2>/dev/null)
  if [[ -n "$NVIM_WIN" ]]; then
    NVIM_SOCKET="$SOCKET"
    break
  fi
done

if [[ -n "$NVIM_WIN" ]]; then
  # Found a running nvim - focus kitty, the tab, and the window
  WIN_ID=$(echo "$NVIM_WIN" | jq -r '.win')
  export KITTY_LISTEN_ON="unix:$NVIM_SOCKET"
  open -a kitty 2>/dev/null
  kitty @ focus-window --match "id:$WIN_ID" 2>/dev/null
  kitty @ send-text --match "id:$WIN_ID" ":e ${FILE}\r" 2>/dev/null
elif [[ -n "$ALIVE_SOCKET" ]]; then
  # Kitty running but no nvim - open a new kitty tab with nvim
  export KITTY_LISTEN_ON="unix:$ALIVE_SOCKET"
  open -a kitty 2>/dev/null
  kitty @ launch --type=tab nvim "$FILE" 2>/dev/null
else
  # No kitty running - open a new kitty with nvim
  open -a kitty --args nvim "$FILE"
fi