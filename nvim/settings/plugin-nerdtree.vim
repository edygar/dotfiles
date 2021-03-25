" Make nerdtree look nice
let NERDTreeMinimalUI = 1

" Mnemonic: *p*roject
" Open or close a NERDTree window:
nnoremap <leader>p :call OpenNerdTree()<CR>
nnoremap <leader>P :call OpenNerdTree()<CR>

" Open the project tree and expose current file in the nerdtree
" calls NERDTreeFind if NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! OpenNerdTree()
  if &modifiable && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
  else
    NERDTreeToggle
  endif
endfunction

" Making webicons' folder not purple / green
exec 'autocmd filetype nerdtree hi NERDTreeFlags guifg=#F5C06F ctermfg=gray'
exec 'autocmd filetype nerdtree hi Directory guifg=#F#F5C06F5C06F ctermfg=gray'
exec 'autocmd filetype nerdtree hi NERDTreeDir guifg=#F5C06F ctermfg=gray'

