#!/usr/bin/env bash
COMMAND=$1
source "$(cd "$(dirname "$0")" && pwd)/tmux-defaults.zsh"

if [ -z "$COMMAND" ]; then
	COMMAND=$(find $(echo "$PATH" | tr ":" " ") -mindepth 1 -maxdepth 1 \( -type l -o -type f \) -exec basename {} \; | FZF_DEFAULT_OPTS="$FZF_LAYOUT" fzf --preview 'MAN_PAGER=less man {} || {} --help | less')
fi

if man "$COMMAND"; then
	exit 0
fi

if $COMMAND --help | nvim -u "$HOME/.config/nvim/minimal-init.lua" -c "Man!" o -; then
	exit 0
fi

if $COMMAND -h | nvim -u "$HOME/.config/nvim/minimal-init.lua" -c "Man!" o -; then
	exit 0
fi

echo "No manual entry for $COMMAND" | less
exit -1
