local Util = require("lazyvim.util")
local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, customOpts)
  local keys = require("lazy.core.handler").handlers.keys
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    customOpts = vim.tbl_extend("keep", customOpts or {}, opts)
    vim.keymap.set(mode, lhs, rhs, customOpts)
  end
end

-- Utils
map("t", "<C-Esc>", "<C-\\><C-n>", { desc = "Open Lazy Dialog" })
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy Dialog" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save current buffer and quit" })
map("n", "<leader>ww", "<cmd>w<cr>", { silent = true, desc = "Save current buffer" })
map("n", "<leader>wa", "<cmd>wa<cr>", { silent = true, desc = "Save all open buffers" })
map("n", "<leader>wF", function()
  require("lazyvim.plugins.lsp.format").toggle()
  vim.cmd("w")
  require("lazyvim.plugins.lsp.format").toggle()
end, { desc = "Save current buffer unformatted" })
map("n", "<C-M-q>", "<cmd>bd<CR>", { silent = true, desc = "Close current window" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Toggles search highlight" })
map("n", "<esc><esc>", "<cmd>nohlsearch<cr>", { desc = "Toggles search highlight" })
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>gv<ESC>:%s//<C-R>0]], opts)
vim.cmd([[
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
]])

-- vim.keymap.set(
--   "n",
--   "<leader>rs",
--   "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>",
--   { noremap = true, silent = true, desc = "Reload snippets" }
-- )

-- copy current filename into system clipboard
-- this is helpful to paste someone the path you're looking at
-- Mnemonic: (c)urrent (f)ull filename (Eg.: ~/.yadr/nvim/settings/vim-keymaps.vim)
map("n", "ycf", "<cmd>let @* = expand('%:~')<CR>", { desc = "Copy current file's absolute path" })
-- Mnemonic: (c)urrent (r)elative filename (Eg.: nvim/settings/vim-maps.vim)
map("n", "ycr", "<cmd>let @* = expand('%')<CR>", { desc = "Copy current file's relative path" })
-- Mnemonic: (c)urrent (n)ame of the file (Eg.: vim-maps.vim)
map("n", "ycn", "<cmd>let @* = expand('%:t')<CR>", { desc = "Copy current file's name" })
map("n", "ycb", "<cmd>let @* = expand('%:t')<CR>", { desc = "Copy current file's name" })
-- Current Branch
map("n", "<leader>gi", function()
  -- Get the branch name by executing a shell command
  local prefix = vim.fn.systemlist([[git branch --show-current | sed -E 's/(FRR-[0-9]+)-.*/\1 - /']])[1]
  vim.api.nvim_feedkeys("OO" .. prefix, "n", false)
end, { expr = true, desc = "Insert current branch name" })
-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Up" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Down" })

-- Window navigation
map("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", { desc = "Go to lower window" })
map("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", { desc = "Go to left window" })
map("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", { desc = "Go to right window" })

map("n", "<C-S-l>", [[<cmd>vertical resize +5<cr>]], { desc = "make the window biger vertically" })
map("n", "<C-S-h>", [[<cmd>vertical resize -5<cr>]], { desc = "Make the window smaller vertically" })
map("n", "<C-S-j>", [[<cmd>horizontal resize +2<cr>]], { desc = "Make the window bigger horizontally" })
map("n", "<C-S-k>", [[<cmd>horizontal resize -2<cr>]], { desc = "Make the window smaller horizontally" })

-- Window organization
map("n", "<leader>vv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>ss", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Tabs --
map("n", "te", ":tabedit %<cr>", { desc = "New tab" })
map("n", "tt", ":tabnew<cr>", { desc = "New tab" })
map("n", "tj", ":tabprevious<cr>", { desc = "Previous tab" })
map("n", "tk", ":tabnext<cr>", { desc = "Next tab" })
map("n", "tc", ":tabclose<cr>", { desc = "Close tab" })
map("n", "to", ":tabonly<cr>", { desc = "Close all other tab" })

-- toggle options
map("n", "<leader>of", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>os", function()
  Util.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>ow", function()
  Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ol", function()
  Util.toggle("relativenumber", true)
  Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>od", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>oc", function()
  Util.toggle("conceallevel", false, { 0, conceallevel })
  if vim.o.conceallevel == 0 then
    -- require("tailwind-fold").disable()
  else
    -- require("tailwind-fold").enable()
  end
end, { desc = "Toggle Conceal" })

vim.api.nvim_create_user_command("ShowBufferInfo", function()
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  print("Current buffer name: " .. buf_name)
  print("Current filetype: " .. filetype)
end, {})
map("n", "<leader>DD", ":ShowBufferInfo<cr>", { desc = "Debug" })
