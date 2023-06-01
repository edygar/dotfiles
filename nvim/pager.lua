require("init")
require("lualine").hide()
vim.cmd([[
  set shell=bash
  set nospell
  set nocursorline
  set signcolumn=no
  set laststatus=0
  set scrolloff=0
  set virtualedit=all
  set binary
  set noeol 
  set cmdheight=0
  set nonu
  set norelativenumber

  nmap <silent> q :qa!<CR>
  nmap <silent> i :qa!<CR>
  nmap <silent> I :qa!<CR>
  autocmd TermEnter * stopinsert
]])
