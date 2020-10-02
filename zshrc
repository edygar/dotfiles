export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export ZSH="$HOME/.dotfiles/oh-my-zsh"

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
