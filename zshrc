if [[ ! -v ZSH ]]; then
  export ZSH="$HOME/.dotfiles/oh-my-zsh"
fi

source $HOME/.dotfiles/nvm.zsh

SHELL_SESSIONS_DISABLE=1
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

source $HOME/.dotfiles/bin/tmux-defaults.sh
source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/aliases.zsh
source $HOME/.dotfiles/key-bindings.zsh

[[ -f $HOME/.env.zsh ]] && . $HOME/.env.zsh


