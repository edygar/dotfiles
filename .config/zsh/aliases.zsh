# Local overrides
[[ -f $HOME/.aliases.zsh ]] && . $HOME/.aliases.zsh

# Editor
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# ls / eza
alias ls="eza --icons"
alias ll="eza -lah --icons --git"
alias la="eza -a --icons"
alias tree="eza --tree --icons"
alias lh="eza -alt --icons --header | head"

# Misc
alias cat="bat"
alias c="clear"
alias cl="clear"
alias less='less -r'
alias tf='tail -f'
alias l='less'
alias screen='TERM=screen screen'

# Global aliases
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep'
alias -g F='| fzf'

# Functions
function fn() { ls **/*$1* }

function img-data() {
  TYPE=$(file --mime-type -b $1)
  ENC=$(base64 -i $1)
  echo "data:$TYPE;base64,$ENC"
}
