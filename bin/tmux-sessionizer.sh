#!/usr/bin/env bash
DEV_HOME=$HOME/dev
HISTORY_FILE=$HOME/.tmux-sessions-history
BIN="$(cd "$(dirname "$0")" && pwd)"
source "$BIN/fzf-defaults.sh"

cd "$DEV_HOME" || exit 1

if [ ! -e HISTORY_FILE ]; then
	touch "$HISTORY_FILE"
fi

current_session=$(tmux display-message -p "#{session_name}")
sessions=$(echo -e "$(fd -a --min-depth 2 --max-depth 2 --type l --type d -x "$BIN/tmux-sessionizer-tokenizer.sh" {})\nHome\t$HOME")

sessions_names=$(echo "$sessions" | awk -F "\t" '{print $1}')
sessions_names=$(grep -v -x -F <(echo "$sessions_names") <"$HISTORY_FILE" | cat - <(echo "$sessions_names") | awk '!a[$0]++' | grep -v -x -F "$current_session")
tmux set pane-border-status top
tmux select-pane -T "Select a session"
pretty=$(echo -e "$sessions_names" | sed 's/^/\\033[37m/g;s/ /\\033[0m /g')
session_name=$(
	echo -e "$pretty" |
		FZF_DEFAULT_OPTS="${FZF_LAYOUT//--keep-right/}" fzf --tiebreak=index --ansi \
			--preview='tmux capture-pane -ep -t '{}' 2>/dev/null || echo "Session not started yet"'
)

tmux set pane-border-status off
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
