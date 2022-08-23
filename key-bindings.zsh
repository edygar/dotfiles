# Accept Autosuggestions
bindkey '^N' autosuggest-accept


function nvim_find_files() {  nvim.sh -c ':Alpha' -c ':UserTelescope find_files'; }
function tmux_sessionizer() {
 $HOME/.dotfiles/bin/tmux-sessionizer.sh;
}

zle -N nvim_find_files
zle -N tmux_sessionizer  

bindkey '^p' nvim_find_files 
bindkey '^f' tmux_sessionizer 
bindkey "\C-[" vi-cmd-mode
