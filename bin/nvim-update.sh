#!/usr/bin/env bash
eval "$(/usr/local/bin/tmux showenv -g ACTIVE_NVIMS 2>/dev/null)"

case "${1}" in
+)
	ACTIVE_NVIMS=$(echo -e "$2$([ -n "$ACTIVE_NVIMS" ] && echo -e "\n$ACTIVE_NVIMS" | tr ":" "\n")" | awk '!a[$0]++' | grep -v "^$")
	/usr/local/bin/tmux set-environment -g ACTIVE_NVIMS "$(echo "$ACTIVE_NVIMS" | tr "\n" ":")"
	;;
-)
	ACTIVE_NVIMS=$(echo -e "$2:$ACTIVE_NVIMS" | tr ":" "\n" | awk '!a[$0]++' | grep -v -x -F "$2")
	/usr/local/bin/tmux set-environment -g ACTIVE_NVIMS "$(echo "$ACTIVE_NVIMS" | tr "\n" ":")"
	;;
esac
