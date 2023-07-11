eval "$(pyenv init -)"
export PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
export VOLTA_HOME="$HOME/.volta"
export PATH="$PATH:$HOME/.dotfiles/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

export PATH="$PATH:$HOME/Library/Python/$PYTHON_VERSION/bin"
export PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
export PATH="$HOME/.pyenv/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
