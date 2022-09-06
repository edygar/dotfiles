#!/usr/bin/env bash
BIN="$(cd "$(dirname "$0")" && pwd)"

open=$(tmux list-panes -F "#{pane_index}:#{pane_start_command}" | grep -F -f <(echo "$BIN/tmux-sessionizer.sh") | awk -F ":" '{print $1}')

SHIFT=3
if [ -z "$1" ]; then
	SHIFT=1
fi

if [ -z "$open" ]; then
	tmux display-popup -B -E \
		-h $((($(tmux display-message -p '#{client_height}') / 2) + SHIFT)) \
		-w 100% \
		-y "$(($(tmux display-message -p '#{client_height}') - SHIFT))" \
		bash -c "SHIFT=$SHIFT $HOME/.dotfiles/bin/tmux-sessionizer.sh" 2>/dev/null
else
	tmux select-pane -t "$open"
fi
