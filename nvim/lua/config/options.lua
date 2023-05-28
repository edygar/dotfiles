-- This file is automatically loaded by plugins.config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.backup = false -- creates a backup file
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
opt.colorcolumn = "120"
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
opt.conceallevel = 3 -- so that `` is visible in markdown files
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- highlight the current line
opt.expandtab = true -- convert tabs to spaces
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.foldenable = false -- disable folding by default
opt.foldmethod = "indent" -- fold based on indent
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = { tab = "> ", trail = "·", nbsp = "·" } -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- set numbered lines
opt.numberwidth = 4 -- set number column width to 2 {default 4}
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- set relative numbered lines
opt.ruler = false
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.shortmess:append({ W = true, I = true, c = true })
opt.showcmd = false
opt.showmode = false -- Dont show mode since we have a statusline
opt.showtabline = 0 -- always show tabs
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spell = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.swapfile = false -- creates a swapfile
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true -- enable persistent undo
opt.undolevels = 10000
opt.updatetime = 0 -- faster completion (4000ms default)
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- display lines as one long line
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Enhancing :find
vim.opt.path:append("**") -- Search down into subfolders

-- Enhancing netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_altv = 1 -- Open with right splitting
vim.g.netrw_liststyle = 3 -- Tree-style view
vim.g.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore

vim.cmd([[
  " Ensure that helptags are generated for the vim help directory
  let g:DocPath = expand("$VIMRUNTIME/doc")
  let g:DocTags = join([g:DocPath, "tags"], "/")
  if !filereadable(g:DocTags)
      execute join(["helptags", g:DocPath])
  endif
]])
