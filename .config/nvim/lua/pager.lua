vim.cmd [[
  set binary
  set buftype=nofile
  set cmdheight=0
  set filetype=man
  set laststatus=0
  set nocursorline
  set noeol 
  set nonu
  set nonumber norelativenumber
  set norelativenumber
  set noruler
  set noshowmode
  set nospell
  set noswapfile
  set scrolloff=0
  set shell=bash
  set showtabline=0
  set signcolumn=no
  set virtualedit=all

  nmap <silent> q :qa!<CR>
  nmap <silent> i :qa!<CR>
  nmap <silent> I :qa!<CR>
  autocmd TermEnter * stopinsert
]]
