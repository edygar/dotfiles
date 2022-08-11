#!/usr/bin/env bash
COMMAND=$1
source "$(cd "$(dirname "$0")" && pwd)/tmux-defaults.sh"

if [ -z "$COMMAND" ]; then
	COMMAND=$(find $(echo "$PATH" | tr ":" " ") -mindepth 1 -maxdepth 1 \( -perm -u=x -type l -o -type f \) -exec basename {} \; | FZF_DEFAULT_OPTS="$FZF_LAYOUT" fzf)
fi

if man "$COMMAND"; then
	exit 0
fi

if $COMMAND --help | MINIMAL=1 nvim -c "Man!" o -; then
	exit 0
fi

if $COMMAND -h | MINIMAL=1 nvim -c "Man!" o -; then
	exit 0
fi

echo "No manual entry for $COMMAND" | less
exit -1
