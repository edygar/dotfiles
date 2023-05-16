M = {}
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("n", "<C-Space>", "<cmd>WhichKey \\<leader><cr>", opts)
keymap("n", "<C-i>", "<C-i>", opts)
keymap("n", "<leader>E", "<cmd>e! %<cr>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
keymap("n", "K", ":lua require('user.functions').show_documentation()<CR>", opts)
keymap("n", "<tab>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)

-- Better window management
-- Window navigation
keymap("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", opts)
keymap("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", opts)
keymap("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", opts)
keymap("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", opts)

-- Window organization
keymap("n", "<leader>vv", "<cmd>vsplit<cr>", opts)
keymap("n", "<leader>ss", "<cmd>split<cr>", opts)

-- Tabs --
keymap("n", "tt", ":tabedit<cr>", opts)
keymap("n", "tk", ":tabprevious<cr>", opts)
keymap("n", "tj", ":tabnext<cr>", opts)
keymap("n", "tc", ":tabclose<cr>", opts)

-- Cycling Lists --
-- Buffers
keymap("n", "[b", "<Plug>(CybuPrev)", opts)
keymap("n", "]b", "<Plug>(CybuNext)", opts)
-- Quickfix
keymap("n", "[q", "<cmd>QPrev<CR>", opts)
keymap("n", "]q", "<cmd>QNext<CR>", opts)

-- Jumplist
keymap("n", "[j", "<C-o>", opts)
keymap("n", "]j", "<C-i>", opts)

-- GIT Chunks
keymap("n", "[g", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", opts)
keymap("n", "]g", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", opts)

-- Harpoon
keymap("n", "[h", '<cmd>lua require("harpoon.ui").nav_prev()<cr>', opts)
keymap("n", "]h", '<cmd>lua require("harpoon.ui").nav_next()<cr>', opts)

-- Bookmarrks
keymap("n", "[k", "<cmd>silent BookmarkPrev<cr>", opts)
keymap("n", "]k", "<cmd>silent BookmarkShowAll<cr>", opts)

-- Plugins
keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>", opts)

-- Hop between worlds in the Buffers
keymap("n", "<leader><leader>", "<cmd>HopWord<cr>", { silent = true })
--[[ keymap("v", "<leader><leader>", "<cmd>HopWord<cr>", { silent = true }) ]]

-- copy current filename into system clipboard
-- this is helpful to paste someone the path you're looking at
-- Mnemonic: (c)urrent (f)ull filename (Eg.: ~/.yadr/nvim/settings/vim-keymaps.vim)
keymap("n", "<leader>cf", "<cmd>let @* = expand('%:~')<CR>", opts)
-- Mnemonic: (c)urrent (r)elative filename (Eg.: nvim/settings/vim-keymaps.vim)
keymap("n", "<leader>cr", "<cmd>let @* = expand('%')<CR>", opts)
-- Mnemonic: (c)urrent (n)ame of the file (Eg.: vim-keymaps.vim)
keymap("n", "<leader>cn", "<cmd>let @* = expand('%:t')<CR>", opts)

-- (v)im (r)eload
keymap("n", "<leader>vr", '<cmd>lua require("user.reload").reload()<CR>', opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", [[ <esc><esc><C-w>h ]], term_opts)
keymap("t", "<C-j>", [[ <esc><esc><C-w>j ]], term_opts)
keymap("t", "<C-k>", [[ <esc><esc><C-w>k ]], term_opts)
keymap("t", "<C-l>", [[ <esc><esc><C-w>l ]], term_opts)

-- Custom
keymap("n", "<esc><esc>", "<cmd>nohlsearch<cr>", opts)
keymap("n", "<A-q>", "<cmd>lua require('user.functions').smart_quit()<CR>", opts)
keymap("n", "<A-w>", "<cmd>:w<CR>", opts)
keymap("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>gv<ESC>:%s//<C-R>0]], opts)
keymap("n", "<C-p>", "<cmd>UserTelescope find_files<CR>", opts)
keymap("n", "gx", [[:silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)

vim.cmd [[
  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]]

vim.cmd [[
  function! s:GotoFirstFloat() abort
    for w in range(1, winnr('$'))
      let c = nvim_win_get_config(win_getid(w))
      if c.focusable && !empty(c.relative)
        execute w . 'wincmd w'
      endif
    endfor
  endfunction

  noremap <c-w><space> :<c-u>call <sid>GotoFirstFloat()<cr>
]]
return M
