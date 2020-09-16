" Making webicons' folder not purple / green
hi NERDTreeFlags guifg=#F5C06F ctermfg=gray
hi Directory guifg=#F5C06F ctermfg=gray
hi NERDTreeDir guifg=#F5C06F ctermfg=gray

if exists('+termguicolors')
    let &t_8f = "\<ESC>[38;2;%lu;%lum"
    let &t_8b = "\<ESC>[48;2;%lu;%lum"
endif

let g:gruvbox_italic=1
let g:gruvbox_italicize_comments=0

" Making webicons' folder not purple / green
exec 'autocmd filetype nerdtree hi NERDTreeFlags guifg=#F5C06F ctermfg=gray'
exec 'autocmd filetype nerdtree hi Directory guifg=#F5C06F ctermfg=gray'
exec 'autocmd filetype nerdtree hi NERDTreeDir guifg=#F5C06F ctermfg=gray'
