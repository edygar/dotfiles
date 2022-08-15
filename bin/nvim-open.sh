#!/usr/bin/env bash
file="${*}"
if [ "${file::1}" != "/" ]; then
	file="$(pwd)/$file"
fi

if ! /usr/local/bin/tmux info &>/dev/null; then
	/usr/bin/osascript -e 'tell application "Alacritty" to activate'
	/usr/local/bin/tmux new -d -s Home -c "$HOME" "$HOME/.dotfiles/bin/nvim.sh" "$file"
	exit 0
fi

active_nvims=$(/usr/local/bin/tmux showenv -g ACTIVE_NVIMS | sed 's/ACTIVE_NVIMS=//;s/:/\n/g')
last_nvim_server=$(echo "$active_nvims" | head -n 1)
last_session_id="\$$(echo "$last_nvim_server" | sed 's#/tmp/nvim.@##;s/_.*$//')"
last_session_name="$(/usr/local/bin/tmux ls -F "#{session_id}=#{session_name}" | grep "$last_session_id" | sed "s/.*=//")"

/usr/local/bin/tmux switch -t "$last_session_name"
/usr/local/bin/nvim --server "${last_nvim_server//@/$}" --remote-send ":e '$file'<CR>"
