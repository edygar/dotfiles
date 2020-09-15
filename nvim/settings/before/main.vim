" This is where you can configure anything that needs to be loaded or
" configured before the rest of the configuration and/or before some plugin
" get loaded. For example, changing the leader key to your desire.
"
" Just put a new .vim file in this folder and it will get sourced here. Those
" files will be ignored by git so you don't need to fork the repo just for
" these kind of customizations.

let customSettingsPath = '~/.config/nvim/settings/before'

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before loading all the plugins.
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

for fpath in split(globpath(customSettingsPath, '*.vim'), '\n')
  if (fpath != expand(customSettingsPath) . "/main.vim") " skip main.vim (this file)
    exe 'source' fpath
  endif
endfor
