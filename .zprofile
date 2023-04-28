PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/Library/Python/$PYTHON_VERSION/bin"
PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
PATH="$HOME/.pyenv/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(pyenv init -)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/edygar.oliveira/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/edygar.oliveira/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/edygar.oliveira/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/edygar.oliveira/google-cloud-sdk/completion.zsh.inc'; fi
