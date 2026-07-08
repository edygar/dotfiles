# XDG base directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# zsh configuration
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export SHELL_SESSIONS_DISABLE=1

# Minimal path (mise shims first so mise-managed tools take priority)
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$HOME/nvim/bin:$HOME/.cargo/bin:/opt/homebrew/bin:$PATH"
