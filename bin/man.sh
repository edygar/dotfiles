#!/usr/bin/env bash
COMMAND=$1
source "$(cd "$(dirname "$0")" && pwd)/fzf-defaults.sh"

if [ -z "$COMMAND" ]; then
	COMMAND=$(fd . $(echo "$PATH" | tr ":" " ") --min-depth 1 --max-depth 2 -t x -X basename {} | FZF_DEFAULT_OPTS="$FZF_LAYOUT" fzf --preview 'man -P "less" {} || {} --help 2>/dev/null || echo "No preview"')
fi

if [ -z "$COMMAND" ]; then
	exit 0
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
exit 1
