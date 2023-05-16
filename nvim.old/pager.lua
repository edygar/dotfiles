require "user.options"
require "user.keymaps"
require "user.colorscheme"

vim.cmd.source(vim.fn.stdpath "data" .. "/site/pack/packer/start/vim-kitty-navigator/plugin/kitty_navigator.vim")

vim.cmd [[
  packadd hop.nvim
  packadd vim-indentobject
  packadd numb.nvim

  set shell=bash
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
]]

require("hop").setup()
