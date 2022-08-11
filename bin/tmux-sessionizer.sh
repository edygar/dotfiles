#!/usr/bin/env bash
DEV_HOME=$HOME/dev
HISTORY_FILE=$HOME/.tmux-sessions-history
source "$(cd "$(dirname "$0")" && pwd)/tmux-defaults.sh"

cd $DEV_HOME

if [ ! -e HISTORY_FILE ]; then
	touch "$HISTORY_FILE"
fi

current_session_name=$(tmux display-message -p '#S')
current_session=$(echo $current_session_name | tr " " "/" | tr "_" ".")

sessions=$(find * -mindepth 1 -maxdepth 1 \( -type l -o -type d \) | cat - <(echo "Home"))
sessions=$(cat "$HISTORY_FILE" | grep -v -x -F <(echo "$sessions") | cat - <(echo -e "$sessions") | awk '!a[$0]++' | grep -v -x -F $(echo "$current_session"))
session=$(echo "$sessions" | FZF_DEFAULT_OPTS="$FZF_LAYOUT" fzf --tiebreak=index --preview='echo "{}" | tr "/" " " | tr "." "_" | xargs tmux capture-pane -ep -t 2>/dev/null || echo "Session not started yet"')

session_name=$(echo $session | tr "/" " " | tr "." "_")
tmux_running=false

if [ -z "$session" ]; then
	exit 0
fi

if [ "$session" == "Home" ]; then
	session_name="Home"
	session="$HOME"
  echo -e "Home\n$current_session\n$sessions" | awk '!a[$0]++' >"$HISTORY_FILE"
else
  echo -e "$session\n$current_session\n$sessions" | awk '!a[$0]++' >"$HISTORY_FILE"
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
