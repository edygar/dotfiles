" Use Q to intelligently close a window
" (if there are multiple windows into the same buffer)
" or kill the buffer entirely if it's the last window looking into that buffer
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  " We should never bdelete a nerd tree
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction


nnoremap <silent> <C-q> :q<CR>

""""""""""""""""
" Easier window resizing
nnoremap <S-Up> <C-w>+
nnoremap <S-Down> <C-w>-
nnoremap <S-Left> <C-w><
nnoremap <S-Right> <C-w>>

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

"""""""""""""""""""
" Splits
set splitright " Vertical split on right

" Remaps 2x <Esc> to exit terminal-mode
" - One <Esc> only will exit command line insert mode to command line normal
"   mode (Vim's window will still be in "terminal" mode)
" - Second <Esc> will exit "terminal" mode on that window and make the whole
"   window into normal mode.
tnoremap <Esc><Esc> <C-\><C-n>

" Please also see the mappings for navigating out of a terminal window in
" plugin-tmux-navigator.vim file
"
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-l> <C-W>l
nmap <C-h> <C-W>h

" Don't allow any default key-mappings.
let g:tmux_navigator_no_mappings = 1

" Re-enable tmux_navigator.vim default bindings, minus <c-\>.
" <c-\> conflicts with NERDTree "current file".

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
tnoremap <silent> <c-h> <c-\><c-n>:TmuxNavigateLeft<cr>
tnoremap <silent> <c-j> <c-\><c-n>:TmuxNavigateDown<cr>
tnoremap <silent> <c-k> <c-\><c-n>:TmuxNavigateUp<cr>
tnoremap <silent> <c-l> <c-\><c-n>:TmuxNavigateRight<cr>

" Tmux sessionizer
nnoremap <silent> <C-f> :silent !tmux neww tmux-sessionizer<CR>
