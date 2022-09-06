#!/usr/bin/env bash
DEV_HOME=$HOME/dev
HISTORY_FILE=$HOME/.tmux-sessions-history
BIN="$(cd "$(dirname "$0")" && pwd)"

cd "$DEV_HOME" || exit 1

if [ ! -e HISTORY_FILE ]; then
	touch "$HISTORY_FILE"
fi

current_session=$(tmux display-message -p "#{session_name}")
sessions_names=$(grep -v -x -F "$current_session" <"$HISTORY_FILE" || "$BIN/tmux-sessionizer-ls.sh" -- "#{name}")

pretty=$(echo -e "$sessions_names" | sed 's/^/\\033[37m/g;s/ /\\033[0m /g')

title=" Select a session "
half=$(((($(tmux display-message -p '#{client_width}') - ${#title})) / 2))
head -c "$half" </dev/zero | tr '\0' '─'
printf "%b" "\\033[38;2;192;138;86m$title\\033[0m"
head -c "$half" </dev/zero | tr '\0' '─'

if [ -n "$*" ]; then
	session_name="$*"
else
	session_name=$(
		echo -e "$pretty" |
			FZF_DEFAULT_OPTS="${FZF_LAYOUT//--keep-right/}" fzf --tiebreak=index --height "$(($(tmux display-message -p '#{client_height}') / 2 - 1 + SHIFT))" --ansi \
				--preview='tmux capture-pane -ep -t '{}' 2>/dev/null || echo "Session not started yet"'
	)
fi
sessions=$("$BIN/tmux-sessionizer-ls.sh" -s -o)

if [ -z "$session_name" ]; then
	exit 0
fi

session_name=$(echo "$session_name" | xargs)
session_path="$(echo -e "$sessions" | grep -F "${session_name//\\s/\\ /}" | awk -F "\t" '{print $2}')"

if tmux info &>/dev/null; then
	tmux_running=true
fi

echo -e "$session_name\n$current_session" | cat - <(echo "$sessions_names" | grep -v -x -F "$session_name") >"$HISTORY_FILE"

if ! tmux has-session -t "$session_name" 2>/dev/null; then
	tmux new-session -s "$session_name" -c "$session_path" "$([ $tmux_running = true ] && echo "-d")"
fi

if [ $tmux_running == true ] && [ -n "$TMUX" ]; then
	tmux switch-client -t "$session_name"
else
	tmux attach-session -t "$session_name"
fi
