#!/usr/bin/env zsh
export LANG="en_US.UTF-8"

# >>> Revolut OpenCode provider API keys >>>
# Managed by Jamf for Revolut OpenCode. Do not edit inside this block.
load_together_ai_coding_api_key_0() {
  if [[ -z "${TOGETHER_AI_CODING_API_KEY:-}" ]]; then
    local provider_key
    provider_key="$(/usr/bin/security find-generic-password -s 'together-ai-coding-api-key' -w /Library/Keychains/System.keychain 2>/dev/null)" || return 1
    export TOGETHER_AI_CODING_API_KEY="$provider_key"
  fi
}
load_together_ai_coding_api_key_0 >/dev/null 2>&1
unset -f load_together_ai_coding_api_key_0 2>/dev/null || true

load_fireworks_non_coding_api_key_0() {
  if [[ -z "${FIREWORKS_NON_CODING_API_KEY:-}" ]]; then
    local provider_key
    provider_key="$(/usr/bin/security find-generic-password -s 'fireworks-non-coding-api-key' -w /Library/Keychains/System.keychain 2>/dev/null)" || return 1
    export FIREWORKS_NON_CODING_API_KEY="$provider_key"
  fi
}
load_fireworks_non_coding_api_key_0 >/dev/null 2>&1
unset -f load_fireworks_non_coding_api_key_0 2>/dev/null || true

# <<< Revolut OpenCode provider API keys <<<



# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Man pages
export MANPAGER="nvim +Man!"

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# fzf
export FZF_DEFAULT_OPTS="--cycle --pointer=▎ --marker=▎"
source <(fzf --zsh)

# mise
eval "$(mise activate zsh)"

# starship
eval "$(starship init zsh)"

# zsh-autosuggestions
[[ -f "$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Source shell configs
[[ -f "$ZDOTDIR/aliases.zsh" ]] && source "$ZDOTDIR/aliases.zsh"
[[ -f "$ZDOTDIR/key-bindings.zsh" ]] && source "$ZDOTDIR/key-bindings.zsh"

# Aliases
alias dotfiles="git --git-dir=$HOME/Code/personal/dotfiles --work-tree=$HOME"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."

alias ls="eza"
alias ll="eza -lah"
alias la="eza -a"
alias tree="eza --tree"

alias cat="bat"

alias vim="nvim"
alias vi="nvim"

alias g="git"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
