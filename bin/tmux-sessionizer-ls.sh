#!/usr/bin/env bash
# shellcheck disable=SC2068
DEV_HOME=$HOME/dev
BIN="$(cd "$(dirname "$0")" && pwd)"
cd "$DEV_HOME" || exit 1

params=()
sort=false
omit=false

TEMP=$(getopt -o a::,f::,s:,o: --long colors::,format::,sort:,omit-current: -- "$@")
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true; do
	case "$1" in
	-c | --colors)
		params+=("--colors")
		shift
		;;
	-o | --omit-current)
		omit=true
		shift
		;;
	-s | --sort)
		sort=true
		shift
		;;
	--)
		shift
		break
		;;
	*)
		shift
		;;
	esac
done

params+=("--" "$@")

# Intentionally splitting
IFS=' '
output="$(echo -e "$(
	fd \
		--absolute-path \
		--min-depth 2 \
		--max-depth 2 \
		--type l \
		--type d \
		--exec "$BIN/tmux-sessionizer-tokenizer.sh" --path="{}" ${params[@]}
)\n$(
	echo -e "$HOME" |
		xargs -I{} "$BIN/tmux-sessionizer-tokenizer.sh" --path="{}" ${params[@]}
)")"

current_session=$(tmux display-message -p "#{session_name}")
if $omit; then
	output="$(echo "$output" | grep -v -F "${current_session//\\s/\\ /}")"
fi

if ! $sort; then
	echo -e "$output"
	exit 0
fi

output=$(echo -e "$output")

if $omit; then
	output="$(echo "$output" | grep -v -x -F "${current_session//\\s/\\ /}")"
fi

echo -e "$output"
