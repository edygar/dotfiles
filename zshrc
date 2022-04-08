if [[ ! -v ZSH ]]; then
  export ZSH="$HOME/.dotfiles/oh-my-zsh"
fi
source $HOME/.dotfiles/nvm.zsh

ZSH_THEME="agnoster"
SOLARIZED_THEME="dark"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
EDITOR="nvim"
HIST_STAMPS="yyyy-mm-dd"
FZF_BASE=$(brew --prefix)/opt/fzf/install
plugins=(git fasd vi-mode zsh-autosuggestions fzf)

source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/aliases.zsh
source $HOME/.dotfiles/key-bindings.zsh
[[ -f $HOME/.env.zsh ]] && . $HOME/.env.zsh
