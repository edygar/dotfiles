local Util = require("lazyvim.util")
local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Utils
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy Dialog" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save current buffer and quit" })
map("n", "<leader>w", "<cmd>w<cr>", { silent = true, desc = "Save current buffer" })
map("n", "<M-q>", "<cmd>bd<CR>", { silent = true, desc = "Close current window" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Toggles search highlight" })
map("n", "<esc><esc>", "<cmd>nohlsearch<cr>", { desc = "Toggles search highlight" })
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>gv<ESC>:%s//<C-R>0]], opts)
vim.cmd([[
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
]])

-- copy current filename into system clipboard
-- this is helpful to paste someone the path you're looking at
-- Mnemonic: (c)urrent (f)ull filename (Eg.: ~/.yadr/nvim/settings/vim-keymaps.vim)
map("n", "ycf", "<cmd>let @* = expand('%:~')<CR>", opts)
-- Mnemonic: (c)urrent (r)elative filename (Eg.: nvim/settings/vim-maps.vim)
map("n", "ycr", "<cmd>let @* = expand('%')<CR>", opts)
-- Mnemonic: (c)urrent (n)ame of the file (Eg.: vim-maps.vim)
map("n", "ycn", "<cmd>let @* = expand('%:t')<CR>", opts)

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

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
map("n", "<leader>vv", "<cmd>vsplit<cr>", opts)
map("n", "<leader>ss", "<cmd>split<cr>", opts)

-- Tabs --
map("n", "tt", ":tabnew<cr>", opts)
map("n", "tj", ":tabprevious<cr>", opts)
map("n", "tk", ":tabnext<cr>", opts)
map("n", "tc", ":tabclose<cr>", opts)

-- Better visual put
map({ "v", "x" }, "p", '"_dP', opts)
map({ "v", "x" }, "P", '"_Dp', opts)

-- toggle options
map("n", "<leader>of", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>ob", function()
  Util.toggle("spell")
end, { desc = "Toggle Spelling" })
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
end, { desc = "Toggle Conceal" })
