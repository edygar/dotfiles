#!/usr/bin/env zsh
export LANG="en_US.UTF-8"

[[ -f $HOME/.zprofile ]] && . $HOME/.zprofile
[[ -f $HOME/.env.zsh ]] && . $HOME/.env.zsh

RUSTC_WRAPPER=sccache
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
source "$HOME/.dotfiles/aliases.sh"
source "$HOME/.dotfiles/key-bindings.sh"
eval "$(zoxide init zsh)"
source "$FZF_BASE/shell/key-bindings.zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
