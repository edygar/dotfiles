" The tree buffer makes it easy to drill down through the directories of your
" git repository, but it‚Äôs not obvious how you could go up a level to the
" parent directory. Here‚Äôs a mapping of .. to the above command, but
" only for buffers containing a git blob or tree
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Every time you open a git object using fugitive it creates a new buffer.
" This means that your buffer listing can quickly become swamped with
" fugitive buffers. This prevents this from becomming an issue:

autocmd BufReadPost fugitive://* set bufhidden=delete

" Mappings
" ============================
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove

" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>dg :diffget<CR>
nnoremap <silent> <leader>dp :diffput<CR>

