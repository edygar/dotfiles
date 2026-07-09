vim.opt.termguicolors = true

-- ============================================================================
-- PLUGINS (vim.pack - nvim 0.12+)
-- ============================================================================
vim.pack.add({
	-- Theme
	"https://github.com/LunarVim/onedarker.nvim",

	-- UI
	"https://github.com/folke/snacks.nvim",
	"https://github.com/folke/noice.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",

	-- LSP
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},

	-- Treesitter
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/ruifm/gitlinker.nvim",

	-- Editing
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/smoka7/hop.nvim",
	"https://github.com/mbbill/undotree",
	"https://github.com/arthurxavierx/vim-caser",

	-- Navigation
	"https://github.com/Bekaboo/dropbar.nvim",
	"https://github.com/kevinhwang91/nvim-bqf",

	-- Diagnostics
	"https://github.com/folke/trouble.nvim",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/rachartier/tiny-code-action.nvim",

	-- Search
	"https://github.com/MagicDuck/grug-far.nvim",

	-- Snippets
	"https://github.com/L3MON4D3/LuaSnip",

	-- Misc
	"https://github.com/echasnovski/mini.nvim",
	"https://github.com/okuuva/auto-save.nvim",
	"https://github.com/Juksuu/worktrees.nvim",
	"https://github.com/knubie/vim-kitty-navigator",
})

-- ============================================================================
-- THEME
-- ============================================================================
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "onedarker",
	callback = function()
		local groups = {
			"Normal", "NormalNC", "EndOfBuffer", "NormalFloat", "FloatBorder",
			"SignColumn", "StatusLine", "StatusLineNC", "TabLine", "TabLineFill",
			"TabLineSel", "ColorColumn", "FoldColumn", "CursorLine",
		}
		for _, g in ipairs(groups) do
			vim.api.nvim_set_hl(0, g, { bg = "none" })
		end
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
		vim.api.nvim_set_hl(0, "LineNr", { bg = "#1E1E1E" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#262626" })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1c1c1e" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#1E1E1E" })
		vim.api.nvim_set_hl(0, "Title", { bold = false, bg = "none", fg = "#519FDF" })
		vim.api.nvim_set_hl(0, "WinBar", { bg = "none" })
		vim.api.nvim_set_hl(0, "WinBarNC", { bg = "none", fg = "none" })
		vim.api.nvim_set_hl(0, "Whitespace", { fg = "#808080", bg = "none" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "#301111", fg = "#DB4B4B" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "#342713", fg = "#EEAF58" })
		vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#163003" })
		vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4B1818" })
		vim.api.nvim_set_hl(0, "DiffChange", { bg = "#0B1802" })
		vim.api.nvim_set_hl(0, "DiffText", { bg = "#163003" })
	end,
})

vim.cmd.colorscheme("onedarker")

-- ============================================================================
-- OPTIONS
-- ============================================================================
local opt = vim.opt
opt.autowrite = true
opt.backup = false
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.colorcolumn = "120"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.conceallevel = 3
opt.confirm = true
opt.cursorline = true
opt.cursorlineopt = "both"
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.foldenable = false
opt.foldmethod = "indent"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.list = true
opt.listchars = { tab = "> ", trail = "·", nbsp = "·" }
opt.mouse = "a"
opt.number = false
opt.numberwidth = 6
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = false
opt.ruler = false
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 2
opt.showcmd = false
opt.showmode = false
opt.showtabline = 1
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.spell = true
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 1000
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
opt.writebackup = false
opt.statuscolumn = "%{v:lnum} %=%{v:relnum} %s"

-- ============================================================================
-- KEYMAPS
-- ============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Movement
map("n", "j", function() return vim.v.count == 0 and "gj" or "j" end, { expr = true, silent = true })
map("n", "k", function() return vim.v.count == 0 and "gk" or "k" end, { expr = true, silent = true })
map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search" })
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buffer" })

-- Window navigation (kitty-navigator handles cross-app)
map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vsplit" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split" })

-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Yank file path
map("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	if path ~= "" then vim.fn.setreg("+", path); vim.notify("Yanked: " .. path) end
end, { desc = "Copy file path" })

-- Snacks picker
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live Grep" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>e", function() Snacks.picker.explorer() end, { desc = "Explorer" })
map("n", "<leader>fw", function() Snacks.picker.worktrees() end, { desc = "Worktrees" })

-- Git
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff view" })
map("n", "<leader>gD", "<cmd>DiffviewOpen master..HEAD<cr>", { desc = "Diff since master" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Git history" })
map("n", "<leader>gy", function() require("gitlinker").get_buf_range_url("n") end, { desc = "Git link" })

-- Search & replace
map("n", "<leader>ss", function() require("grug-far").open() end, { desc = "Find & replace" })
map("n", "<leader>sw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, { desc = "Replace word" })

-- Hop
map({ "n", "v" }, "<leader><leader>", function() require("hop").hint_words() end, { desc = "Jump" })

-- Oil
map("n", "<leader>E", function() require("oil").open() end, { desc = "Oil" })

-- Undotree
map("n", "<leader>U", "<cmd>UndotreeToggle<CR>", { desc = "Undo tree" })

-- Dropbar
map("n", "<leader>j", "<cmd>lua require('dropbar.api').pick()<CR>", { desc = "Breadcrumbs" })

-- Treesitter node selection (replaces syntax-tree-surfer)
map("n", "vv", function()
	local ts = vim.treesitter
	local buf = vim.api.nvim_get_current_buf()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local node = ts.get_node({ bufnr = buf, pos = { row - 1, col } })
	if not node then return end
	local sr, sc, er, ec = node:range()
	vim.api.nvim_buf_set_mark(buf, "<", sr + 1, sc, {})
	vim.api.nvim_buf_set_mark(buf, ">", er + 1, ec - 1, {})
	vim.cmd("normal! gv")
end, { desc = "Select treesitter node", silent = true })

map("x", "<C-M-Left>", function()
	local ts = vim.treesitter
	local node = ts.get_node()
	if node and node:parent() then
		node = node:prev_sibling() or node
	end
	if node then
		local sr, sc, er, ec = node:range()
		vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
		vim.cmd("normal! v")
		vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
	end
end, { desc = "Prev sibling node", silent = true })

map("x", "<C-M-Right>", function()
	local ts = vim.treesitter
	local node = ts.get_node()
	if node and node:parent() then
		node = node:next_sibling() or node
	end
	if node then
		local sr, sc, er, ec = node:range()
		vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
		vim.cmd("normal! v")
		vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
	end
end, { desc = "Next sibling node", silent = true })

map("x", "<C-M-Up>", function()
	local ts = vim.treesitter
	local node = ts.get_node()
	if node and node:parent() then
		node = node:parent()
		local sr, sc, er, ec = node:range()
		vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
		vim.cmd("normal! v")
		vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
	end
end, { desc = "Parent node", silent = true })

map("x", "<C-M-Down>", function()
	local ts = vim.treesitter
	local node = ts.get_node()
	if node then
		for child in node:iter_children() do
			if child then
				local sr, sc, er, ec = child:range()
				vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
				vim.cmd("normal! v")
				vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
				return
			end
		end
	end
end, { desc = "Child node", silent = true })

-- Resize
map("n", "<C-S-l>", "<cmd>vertical resize +5<CR>", { desc = "Wider" })
map("n", "<C-S-h>", "<cmd>vertical resize -5<CR>", { desc = "Narrower" })
map("n", "<C-S-j>", "<cmd>horizontal resize +2<CR>", { desc = "Taller" })
map("n", "<C-S-k>", "<cmd>horizontal resize -2<CR>", { desc = "Shorter" })

-- Toggle line numbers
map("n", "<leader>ul", function()
	if vim.o.statuscolumn ~= "" then
		vim.o.statuscolumn = ""
		vim.o.relativenumber = true
		vim.o.number = true
		vim.o.numberwidth = 4
	else
		vim.o.relativenumber = false
		vim.o.number = false
		vim.o.numberwidth = 6
		vim.o.statuscolumn = "%{v:lnum} %=%{v:relnum} %s"
	end
end, { desc = "Toggle line numbers" })

map("n", "<leader>uv", function() require("tiny-inline-diagnostic").toggle() end, { desc = "Toggle diagnostics" })

-- ============================================================================
-- AUTOCMDS
-- ============================================================================
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		if vim.o.diff then return end
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] >= 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================

-- onedarker palette
local palette = require("onedarker.palette")
palette.bg = "NONE"
palette.alt_bg = "#1E1E1E"

-- Snacks
Snacks = require("snacks")
Snacks.setup({
	statuscolumn = { enabled = false },
	explorer = { replace_netrw = true },
	input = { win = { relative = "cursor", title_pos = "left", row = -1 } },
	picker = {
		ui_select = true,
		layout = {
			layout = {
				position = "float", row = 1, width = 0.9, height = 0.9,
				border = "none", box = "vertical",
				{ win = "preview", title = "{preview}", border = "rounded", height = 0.80 },
				{
					box = "vertical", border = "rounded",
					title = "{title} {live} {flags}", title_pos = "left",
					{ win = "input", height = 1, border = "bottom" },
					{ win = "list", border = "none" },
				},
			},
		},
		formatters = { file = { filename_first = true, truncate = 1 / 0 } },
		win = {
			input = { keys = {
				["<c-a-d>"] = { "inspect", mode = { "n", "i" } },
				["<c-a-f>"] = { "toggle_follow", mode = { "i", "n" } },
				["<c-a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
				["<c-a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
				["<c-a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
				["<c-a-p>"] = { "toggle_preview", mode = { "i", "n" } },
				["<c-a-w>"] = { "cycle_win", mode = { "i", "n" } },
			}},
			list = { keys = {
				["<c-a-d>"] = "inspect", ["<c-a-f>"] = "toggle_follow",
				["<c-a-h>"] = "toggle_hidden", ["<c-a-i>"] = "toggle_ignored",
				["<c-a-m>"] = "toggle_maximize", ["<c-a-p>"] = "toggle_preview",
				["<c-a-w>"] = "cycle_win",
			}},
		},
	},
	preview = {},
})

-- vim.ui.select via snacks
vim.ui.select = function(items, opts, on_choice)
	require("snacks").ui.select(items, opts, on_choice)
end

-- Noice
require("noice").setup({
	cmdline = { enabled = true, view = "cmdline" },
	presets = { bottom_search = true, command_palette = true, long_message_to_split = true, lsp_doc_border = true },
})

-- Which-key
require("which-key").setup({
	win = { no_overlap = true, border = "single", padding = { 2, 2, 2, 2 }, wo = { winblend = 10 } },
	layout = { height = { min = 4, max = 25 }, width = { min = 20, max = 50 }, spacing = 3, align = "left" },
	icons = { group = "", rules = false, separator = "-" },
})

-- Mason
require("mason").setup({})

-- Treesitter
local treesitter = require("nvim-treesitter")
treesitter.setup({})
local ensure_installed = {
	"vim", "vimdoc", "rust", "c", "cpp", "go", "html", "css",
	"javascript", "json", "lua", "markdown", "python", "typescript",
	"vue", "svelte", "bash",
}
local config = require("nvim-treesitter.config")
local already = config.get_installed()
local to_install = {}
for _, p in ipairs(ensure_installed) do
	if not vim.tbl_contains(already, p) then table.insert(to_install, p) end
end
if #to_install > 0 then treesitter.install(to_install) end
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function(args)
		if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
			vim.treesitter.start(args.buf)
		end
	end,
})

-- Treesitter context
require("treesitter-context").setup({})

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "▏" }, change = { text = "▐" }, delete = { text = "◦" },
		topdelete = { text = "◦" }, changedelete = { text = "●" }, untracked = { text = "○" },
	},
	signcolumn = true,
})

map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev hunk" })
map("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
map("n", "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
map("n", "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
map("n", "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame" })

-- LSP
local diagnostic_signs = { Error = " ", Warn = " ", Hint = "", Info = "" }
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	severity_sort = true,
	float = { border = "rounded", source = true, header = "", prefix = "", focusable = false, style = "minimal" },
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, o, ...)
		o = o or {}
		o.border = o.border or "rounded"
		return orig(contents, syntax, o, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then return end
	local bufnr = ev.buf
	local o = { noremap = true, silent = true, buffer = bufnr }

	map("n", "<leader>gd", function() Snacks.picker.lsp_definitions() end, o)
	map("n", "<leader>gD", vim.lsp.buf.declaration, o)
	map("n", "<leader>ca", function() require("tiny-code-action").code_action() end, o)
	map("n", "<leader>rn", vim.lsp.buf.rename, o)
	map("n", "K", vim.lsp.buf.hover, o)
	map("n", "<leader>fr", function() Snacks.picker.lsp_references() end, o)
	map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, o)
	map("n", "<leader>fi", function() Snacks.picker.lsp_implementations() end, o)
	map("n", "<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, o)
	map("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, o)
	map("n", "<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, o)
	map("n", "<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, o)
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

-- LSP servers
vim.lsp.config("lua_ls", {
	settings = { Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } } },
})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

vim.lsp.enable({ "lua_ls", "pyright", "bashls", "ts_ls", "gopls", "clangd" })

-- Blink cmp
require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	snippets = { expand = function(snippet) require("luasnip").lsp_expand(snippet) end },
	fuzzy = { implementation = "prefer_rust", prebuilt_binaries = { download = true } },
})

vim.lsp.config["*"] = { capabilities = require("blink.cmp").get_lsp_capabilities() }

-- Mini
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({
	draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() },
	symbol = "▏",
	options = { try_as_border = true },
})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})

-- Tiny inline diagnostic
require("tiny-inline-diagnostic").setup({
	options = { multilines = { enabled = true, always_show = true, trim_whitespaces = false, tabstop = 4 } },
})
vim.diagnostic.config({ virtual_text = false })

-- Tiny code action
require("tiny-code-action").setup({
	backend = "delta",
	picker = { "snacks", opts = { layout = {
		backdrop = 40, position = "float",
		layout = { backdrop = 40, position = "float", row = 1, width = 0.9, height = 0.9,
			border = "none", box = "vertical",
			{ win = "preview", title = "{preview}", height = 0.8, width = 0, border = "rounded" },
			{ box = "vertical", border = "rounded", title = "{title} {live} {flags}", title_pos = "left",
				{ win = "input", height = 1, border = "bottom" }, { win = "list", border = "none" } },
		},
	}}},
})

-- Hop
require("hop").setup({})

-- Oil
require("oil").setup({})

-- nvim-surround
require("nvim-surround").setup({})

-- Gitlinker
require("gitlinker").setup({})

-- Auto-save
require("auto-save").setup({
	enabled = false,
	debounce_delay = 1000,
	trigger_events = {
		immediate_save = { "BufLeave", "FocusLost", "InsertLeave" },
		defer_save = { "InsertLeave", "CursorHoldI", "TextChanged" },
		cancel_deferred_save = { "InsertEnter" },
	},
})

-- Lualine
require("lualine").setup({
	options = { theme = "onedarker", component_separators = { left = "|", right = "|" }, section_separators = { left = "", right = "" } },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "filename" },
		lualine_x = { "diagnostics" },
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})

-- undotree
vim.g.undotree_WindowLayout = 4
vim.g.undotree_SetFocusWhenToggle = 1

-- Float terminal
vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function() if vim.v.event.status == 0 then vim.api.nvim_buf_delete(0, {}) end end,
})
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

local terminal_state = { buf = nil, win = nil, is_open = false }
local function FloatingTerminal()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
		return
	end
	if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
		terminal_state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[terminal_state.buf].bufhidden = "hide"
	end
	terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
		relative = "editor", width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8), row = math.floor((vim.o.lines - vim.o.lines * 0.8) / 2),
		col = math.floor((vim.o.columns - vim.o.columns * 0.8) / 2), style = "minimal", border = "rounded",
	})
	vim.wo[terminal_state.win].winblend = 0
	local has_term = false
	for _, line in ipairs(vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)) do
		if line ~= "" then has_term = true; break end
	end
	if not has_term then vim.fn.termopen(os.getenv("SHELL")) end
	terminal_state.is_open = true
	vim.cmd("startinsert")
end

map("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle terminal" })
map("t", "<Esc>", function()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		vim.api.nvim_win_close(terminal_state.win, false)
		terminal_state.is_open = false
	end
end, { noremap = true, silent = true, desc = "Close terminal" })
