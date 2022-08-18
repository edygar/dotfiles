#!/usr/bin/env bash

DEV_HOME=$HOME/dev

colors=false
path=""
format="#{name}\t#{path}"

echo "$*" >> ~/.thistory
TEMP=$(getopt -o a::,p:: --long colors::,path:: -- "$@")
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true; do
	case "$1" in
	-c | --colors)
		colors=true
		shift
		;;
	-p | --path)
		path="$2"
		shift 2
		;;
	--)
		shift
		if [ -z "$1" ]; then
			break
		fi
		format="$*"
		break
		;;
	*)
		shift
		;;
	esac
done

output="$format"

if [[ "$output" == *"#{name}"* ]]; then
	if [ "$HOME" = "$path" ]; then
		name="Home"
	else
		name="$(echo "${path:${#DEV_HOME}}" | sed 's@/@ @g;s@^.@@g;s@ $@@g')"
	fi

	if $colors; then
		type="$(echo "$name" | awk '{print $1}')"
		color="$((31 + ${#type} % 6))"
		name="$(echo "$name" | awk '{ORS=""; print "\033[1;'"$color"'m"$1"\033[0m"; $1=""; print $0}')"
	fi
	output="${output//#\{name\}/$name}"
fi

output="${output//#\{path\}/$path}"

echo -e "$output"
