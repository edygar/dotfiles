export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.dotfiles/oh-my-zsh"
ZSH_THEME="agnoster"
SOLARIZED_THEME="dark"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
EDITOR="nvim"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git fasd fzf vi-mode)
source $ZSH/oh-my-zsh.sh
