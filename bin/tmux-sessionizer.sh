#!/usr/bin/env bash
DEV_HOME=$HOME/dev
source "$(cd "$(dirname "$0")" && pwd)/tmux-defaults.sh"

cd $DEV_HOME

session=$(find * -mindepth 1 -maxdepth 1 \( -type l -o -type d \) | cat - <(echo "Home") | FZF_DEFAULT_OPTS="$FZF_LAYOUT" fzf --preview='echo "{}" | tr "/" " " | tr "." "_" | xargs tmux capture-pane -ep -t 2>/dev/null || echo "Session not started yet"')

session_name=$(echo $session | tr "/" " " | tr "." "_")
tmux_running=false

if [ "$session" == "Home" ]; then
  session_name="Home"
  session="$HOME"
fi

if [ -z "$session" ]; then
	exit 0
fi

if tmux info &>/dev/null; then
	tmux_running=true
fi

if ! tmux has-session -t "$session_name" 2>/dev/null; then
	tmux new-session -s "$session_name" -c "$session" $($tmux_running == true && echo "-d")
fi

if [[ $tmux_running == true ]] && [[ -n "$TMUX" ]]; then
	tmux switch-client -t "$session_name"
else
	tmux attach-session -t "$session_name"
fi
