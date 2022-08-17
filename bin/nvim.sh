#!/usr/bin/env bash
LISTEN="/tmp/nvim.$(/usr/local/bin/tmux display-message -p '#{session_id}_#I_#P').pipe"
/usr/local/bin/tmux rename-window nvim
/usr/local/bin/tmux select-pane -T "NeoVim"
/usr/local/bin/nvim --listen "$LISTEN" "$@"
