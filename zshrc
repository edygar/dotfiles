#!/bin/zsh
if [[ ! -v ZSH ]]; then
  export ZSH="$HOME/.dotfiles/oh-my-zsh"
fi

source $HOME/.dotfiles/nvm.zsh

# SHELL_SESSIONS_DISABLE=1
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="agnoster"
SOLARIZED_THEME="dark"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION=
COMPLETION_WAITING_DOTS="true"
EDITOR="nvim"
HIST_STAMPS="yyyy-mm-dd"
FZF_BASE=$(brew --prefix)/opt/fzf/install
plugins=(git fasd vi-mode zsh-autosuggestions fzf)


export MANPAGER="MINIMAL=1 nvim -c 'Man!' o -"

. "$HOME/.dotfiles/bin/fzf-defaults.sh"
. "$ZSH/oh-my-zsh.sh"
. "$HOME/.dotfiles/aliases.zsh"
. "$HOME/.dotfiles/key-bindings.zsh"
# . "$HOME/.dotfiles/bin/fns.sh"  

[[ -f $HOME/.env.zsh ]] && . $HOME/.env.zsh

