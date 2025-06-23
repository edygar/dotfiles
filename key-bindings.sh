# enter VI mode
bindkey "\C-[" vi-cmd-mode

# Accept Autosuggestions
bindkey '^N' autosuggest-accept

# Define a function to close the Kitty window
close_kitty_window() {
	kitty @ close-window
}

# Create a zle widget for the function
zle -N close_kitty_window

# Bind the escape sequence to the widget
bindkey '\x1bq' close_kitty_window

function nvims() {
	items=("default" "EdygarNvim" "AstroNvim")
	config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
	if [[ -z $config ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $config == "default" ]]; then
		config=""
	fi
	NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"
