" colorscheme base16-lfilho
" let base16colorspace=256
" let g:hybrid_custom_term_colors = 1
" let g:hybrid_reduced_contrast = 1
"
set encoding=UTF-8


if has("termguicolors")
  set termguicolors
endif

set background=dark

let g:airline_powerline_fonts = 1

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Hide ~ for blank lines
hi NonText guifg=bg
set cursorline

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Resize splits when the window is resized
au VimResized * :wincmd =

