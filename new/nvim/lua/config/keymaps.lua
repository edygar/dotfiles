local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Utils
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Go to left window" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Toggles search highlight" })
map("n", "<esc><esc>", "<cmd>nohlsearch<cr>", { desc = "Toggles search highlight" })
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>gv<ESC>:%s//<C-R>0]], opts)

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", { desc = "Go to left window" })
map("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", { desc = "Go to lower window" })
map("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", { desc = "Go to right window" })

-- Window organization
map("n", "<leader>vv", "<cmd>vsplit<cr>", opts)
map("n", "<leader>ss", "<cmd>split<cr>", opts)

-- Tabs --
map("n", "tt", ":tabedit<cr>", opts)
map("n", "tk", ":tabprevious<cr>", opts)
map("n", "tj", ":tabnext<cr>", opts)
map("n", "tc", ":tabclose<cr>", opts)

-- Better visual put
map({ "v", "x" }, "p", '"_dP', opts)
map({ "v", "x" }, "P", '"_Dp', opts)

map("v", "[e", function()
  require("unimpaired.functions").exchange_above()
  vim.cmd([[ execute normal! gv ]])
end, opts)

map("v", "]e", function()
  require("unimpaired.functions").exchange_below()
  vim.cmd([[ execute normal! gv ]])
end, opts)
