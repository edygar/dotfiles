#!/usr/bin/env bash
BIN="$(cd "$(dirname "$0")" && pwd)"

open=$(tmux list-panes -F "#{pane_index}:#{pane_start_command}" | grep -F -f <(echo "$BIN/tmux-sessionizer.sh") | awk -F ":" '{print $1}')

if [ -z "$open" ]; then
  tmux split-window -f -v -c '#{pane_current_path}' ~/.dotfiles/bin/tmux-sessionizer.sh 2>/dev/null
else
  tmux select-pane -t "$open"
fi
