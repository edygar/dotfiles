# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Edit the current command line in $VISUAL/$EDITOR with `vv` from vi command mode.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

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
