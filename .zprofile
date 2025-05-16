export VOLTA_HOME="$HOME/.volta"
export PYENV_ROOT="$HOME/.pyenv"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$PATH:$HOME/.dotfiles/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/Applications/kitty.app/Contents/MacOS"
export PATH="$PATH:/Applications/Alacritty.app/Contents/MacOS"
export PATH="$PATH:/opt/homebrew/opt/openjdk@21/bin"

export JAVA_HOME="/Users/edygar.oliveira/Library/Java/JavaVirtualMachines/corretto-17.0.12/Contents/Home"

eval "$(/opt/homebrew/bin/brew shellenv)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
