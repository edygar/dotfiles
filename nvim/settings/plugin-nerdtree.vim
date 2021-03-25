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
