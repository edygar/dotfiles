" This file exists under after/ folder because some colorschemes (like
" gruvbox, for example) can take some global configuration options and hence
" they need to be set before choosing the colorscheme.
" So we make sure to only switch on the colorscheme below after we're sure
" it's preconfigured as desidered (under the settings/ folder)
if has("termguicolors")
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

lua require('colorbuddy').colorscheme('gruvbuddy')

hi! Normal     ctermbg=NONE guibg=NONE
hi! LineNr     ctermbg=NONE guibg=NONE
hi! SignColumn ctermbg=NONE guibg=NONE

hi! LspDiagnosticsVirtualTextError       guifg=darkgrey
hi! LspDiagnosticsVirtualTextWarning     guifg=darkgrey
hi! LspDiagnosticsVirtualTextHint        guifg=darkgrey
hi! LspDiagnosticsVirtualTextInformation guifg=darkgrey

hi! LspDiagnosticsSignError              guifg=Red    guibg=18
hi! LspDiagnosticsSignWarning            guifg=Yellow guibg=18
hi! LspDiagnosticsSignHint               guibg=18
hi! LspDiagnosticsSignInformation        guibg=18

hi! link TelescopeNormal GruvboxFg1
hi! link TelescopeSelection GruvboxBlueBold
hi! link TelescopeSelectionCaret GruvboxBlue
hi! link TelescopeMultiSelection GruvboxGray
hi! TelescopeMatching gui=bold,underline
hi! link TelescopePromptPrefix GruvboxBlue

