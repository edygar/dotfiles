let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

set background=dark
colorscheme gruvbox

hi ColorColumn ctermbg=0 guibg=grey
hi Normal guibg=none
" hi LineNr guifg=#ff8659
" hi LineNr guifg=#aed75f
hi LineNr guifg=#5eacd3
hi netrwDir guifg=#5eacd3
hi qfFileName guifg=#aed75f
hi TelescopeBorder guifg=#5eacd

" Better Visual highlight
hi Visual term=inverse ctermbg=247 ctermfg=NONE

" Highlight current line number
hi CursorLineNR cterm=bold ctermfg=1

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
