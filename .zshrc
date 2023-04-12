#!/usr/bin/env zsh


PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/Library/Python/$PYTHON_VERSION/bin"
PATH="$PATH:/Applications/kitty.app/Contents/MacOS"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
SOLARIZED_THEME="dark"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION=
COMPLETION_WAITING_DOTS="true"
EDITOR="nvim"
HIST_STAMPS="yyyy-mm-dd"
FZF_BASE="$HOME/.fzf"


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


plugins=(git fasd vi-mode zsh-autosuggestions fzf)

source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
source "$HOME/.dotfiles/key-bindings.sh"
source "$HOME/.dotfiles/aliases.sh"

[[ -f $HOME/.env.zsh ]] && . $HOME/.env.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/edygar.oliveira/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/edygar.oliveira/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/edygar.oliveira/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/edygar.oliveira/google-cloud-sdk/completion.zsh.inc'; fi
