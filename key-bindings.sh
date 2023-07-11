# enter VI mode
bindkey "\C-[" vi-cmd-mode

# Accept Autosuggestions
bindkey '^N' autosuggest-accept

# Accept Autosuggestions
bindkey '^P' zi

# Define a function to close the Kitty window
close_kitty_window() {
	kitty @ close-window
}

# Create a zle widget for the function
zle -N close_kitty_window

# Bind the escape sequence to the widget
bindkey '\x1bq' close_kitty_window

open_vim() {
	cd "$(pwd)" && vim -c 'Alpha'
}

# Create a zle widget for the function
zle -N open_vim

# Bind the escape sequence to the widget
bindkey '^[o' open_vim

open_vim_with_prompt() {
	cd "$(pwd)" && vim -c 'Alpha' -c 'Telescope find_files'
}

# Create a zle widget for the function
zle -N open_vim_with_prompt

# Bind the escape sequence to the widget
bindkey '^[p' open_vim_with_prompt
