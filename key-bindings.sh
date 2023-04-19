# enter VI mode
bindkey "\C-[" vi-cmd-mode

# Accept Autosuggestions
bindkey '^N' autosuggest-accept

# Accept Autosuggestions
bindkey '^P' zi

# Define a function to close the Kitty window
close_kitty_window() {
  echo "I did run"
	kitty @ close-window
}

# Create a zle widget for the function
zle -N close_kitty_window

# Bind the escape sequence to the widget
bindkey '\x1bq' close_kitty_window
