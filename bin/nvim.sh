#!/usr/bin/env bash
LISTEN="/tmp/nvim.$(tmux display-message -p '#{session_id}_#I_#P').pipe"
tmux rename-window nvim
/usr/local/bin/nvim --listen "$LISTEN" "$@"
