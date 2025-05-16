#!/usr/bin/env zsh
export LANG="en_US.UTF-8"

[[ -f $HOME/.zprofile ]] && . $HOME/.zprofile

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
export PATH="$PATH:$HOME/Library/Python/$PYTHON_VERSION/bin"


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



plugins=(git fasd vi-mode zsh-autosuggestions fzf)

source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
source "$HOME/.dotfiles/aliases.sh"
source "$HOME/.dotfiles/key-bindings.sh"
eval "$(zoxide init zsh)"
source "$FZF_BASE/shell/key-bindings.zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/edygar.oliveira/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/edygar.oliveira/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/edygar.oliveira/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/edygar.oliveira/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/edygar.oliveira/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/edygar.oliveira/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source "/Users/edygar.oliveira/.sdkman/bin/sdkman-init.sh"
