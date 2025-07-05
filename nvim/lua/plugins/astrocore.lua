-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
local get_current_branch = function()
  local ok, branch = pcall(vim.fn.system, "git branch --show-current")

  if not ok then return nil end

  -- Check if git command succeeded (vim.v.shell_error == 0)
  if vim.v.shell_error ~= 0 then return nil end
  return vim.trim(branch)
end

local function map(mode, maps, fn, opts)
  for _, key in ipairs(maps) do
    vim.keymap.set(mode, key, fn, opts)
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    on_keys = {
      -- first key is the namespace
      auto_hlsearch = {
        -- list of functions to execute on key press (:h vim.on_key)
        function(char) -- example automatically disables `hlsearch` when not actively searching
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end,
      },
    },

    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        autowrite = true, -- Enable auto write
        backup = false, -- creates a backup file
        clipboard = "unnamedplus", -- Sync with system clipboard
        cmdheight = 1, -- more space in the neovim command line for displaying messages
        colorcolumn = "120",
        completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
        conceallevel = 3, -- so that `` is visible in markdown files
        confirm = true, -- Confirm to save changes before exiting modified buffer
        cursorline = true, -- highlight the current line
        cursorlineopt = "both",
        expandtab = true, -- convert tabs to spaces
        fileencoding = "utf-8", -- the encoding written to a file
        foldenable = false, -- disable folding by default
        foldenable = false, -- disable folding by default
        foldmethod = "indent", -- fold based on indent
        foldmethod = "indent", -- fold based on indent
        formatoptions = "jcroqlnt", -- tcqj
        grepformat = "%f:%l:%c:%m",
        grepprg = "rg , --vimgrep",
        guifont = "monospace:h17", -- the font used in graphical neovim applications
        hlsearch = true, -- highlight all matches on previous search pattern
        hlsearch = true, -- highlight all matches on previous search pattern
        ignorecase = true, -- ignore case in search patterns
        inccommand = "nosplit", -- preview incremental substitute
        laststatus = 3,
        list = true, -- Show some invisible characters (tabs...
        listchars = { tab = "> ", trail = "·", nbsp = "·" }, -- Show some invisible characters (tabs...
        mouse = "a", -- Enable mouse mode
        number = true, -- set numbered lines
        number = true, -- sets vim.opt.number
        numberwidth = 4, -- set number column width to 2 {default 4}
        pumblend = 10, -- Popup blend
        pumheight = 10, -- Maximum number of entries in a popup
        relativenumber = true, -- set relative numbered lines
        relativenumber = true, -- sets vim.opt.relativenumber
        ruler = false,
        scrolloff = 8, -- Lines of context
        sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
        shiftround = true, -- Round indent
        shiftwidth = 2, -- the number of spaces inserted for each indentation
        showcmd = false,
        showmode = false, -- Dont show mode since we have a statusline
        showtabline = 1, -- always show tabs
        sidescrolloff = 8, -- Columns of context
        signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        smartcase = true, -- Don't ignore case with capitals
        smartindent = true, -- Insert indents automatically
        smartindent = true, -- Insert indents automatically
        spell = false, -- sets vim.opt.spell
        spell = true,
        spelllang = { "en" },
        splitbelow = true, -- Put new windows below current
        splitright = true, -- Put new windows right of current
        swapfile = false, -- creates a swapfile
        swapfile = false, -- creates a swapfile
        tabstop = 2, -- Number of spaces tabs count for
        termguicolors = true, -- set term gui colors (most terminals support this)
        timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
        undofile = true, -- enable persistent undo
        undofile = true, -- enable persistent undo
        undolevels = 10000,
        updatetime = 0, -- faster completion (4000ms default)
        updatetime = 200, -- Save swap file and trigger CursorHold
        wildmode = "longest:full,full", -- Command-line completion mode
        wildmode = "longest:full,full", -- Command-line completion mode
        winminwidth = 5, -- Minimum window width
        wrap = false, -- display lines as one long line
        wrap = false, -- sets vim.opt.wrap
        writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
        writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["<Leader>wq"] = { "<cmd>wq<CR>", desc = "Write and quit" },
        ["<Leader>wa"] = { "<cmd>wa<CR>", desc = "Write all" },
        ["<Leader>fj"] = { "<cmd>lua Snacks.picker.jumps()<CR>", desc = "Lists Jumplist" },
        ["[j"] = { "<C-o>" },
        ["]j"] = { "<C-i>" },

        ["<C-M-q>"] = { "<cmd>bd<CR>", silent = true, desc = "Close current window" },
        ["<Leader>fq"] = {
          function() require("snacks").picker.qflist() end,
          silent = true,
          desc = "Search through quickfix",
        },

        ["<Leader>fe"] = { "<cmd>lua Snacks.picker.explorer()<CR>", desc = "Opens Explorer picker" },

        ["ycf"] = {
          function()
            local filepath = vim.fn.expand "%:p"
            if filepath ~= "" then
              vim.fn.setreg("+", filepath)
              vim.notify("Yanked: " .. filepath)
            else
              vim.notify "No file in current buffer"
            end
          end,
          desc = "Yank current file path",
        },

        -- Yank current relative path
        ["ycr"] = {
          function()
            local filepath = vim.fn.expand "%"
            if filepath ~= "" then
              vim.fn.setreg("+", filepath)
              vim.notify("Yanked: " .. filepath)
            else
              vim.notify "No file in current buffer"
            end
          end,
          desc = "Yank current relative path",
        },

        -- Tabs --
        ["<Leader>h"] = { "<Cmd>noh<CR>", desc = "No highlight" },
        ["te"] = { "<Cmd>tabedit %<CR>", desc = "New tab" },
        ["tt"] = { "<Cmd>tabnew<CR>", desc = "New tab" },
        ["tj"] = { "<Cmd>tabprevious<CR>", desc = "Previous tab" },
        ["tk"] = { "<Cmd>tabnext<CR>", desc = "Next tab" },
        ["tc"] = { "<Cmd>tabclose<CR>", desc = "Close tab" },
        ["to"] = { "<Cmd>tabonly<CR>", desc = "Close all other tab" },

        -- LSP --
        ["<Leader>ln"] = { "<Cmd>lua vim.lsp.buf.rename()<CR>", desc = "Close all other tab" },

        ["<C-S-l>"] = { [[<cmd>vertical resize +5<CR>]], desc = "make the window biger vertically" },
        ["<C-S-h>"] = { [[<cmd>vertical resize -5<CR>]], desc = "Make the window smaller vertically" },
        ["<C-S-j>"] = { [[<cmd>horizontal resize +2<CR>]], desc = "Make the window bigger horizontally" },
        ["<C-S-k>"] = { [[<cmd>horizontal resize -2<CR>]], desc = "Make the window smaller horizontally" },
        ["<Leader>fO"] = { function() require("snacks").picker.recent() end, desc = "Find old files" },
        ["<Leader>fo"] = {
          function() require("snacks").picker.recent { filter = { cwd = true } } end,
          desc = "Find old files (cwd)",
        },

        ["<Leader>e"] = {
          function(current_buf)
            if vim.api.nvim_get_option_value("filetype", { buf = current_buf }) ~= "snacks_picker_list" then
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
                if filetype == "snacks_picker_list" then
                  vim.api.nvim_set_current_win(win)
                  return
                end
              end
            end

            Snacks.picker.explorer()
          end,
          desc = "Opens explorer picker",
        },
        ["<Leader>fP"] = { "<Cmd>lua Snacks.picker()<CR>", desc = "Opens pickers" },
        ["<Leader>fH"] = { "<Cmd>lua Snacks.picker.highlights()<CR>", desc = "Finds highlights" },

        ["<Leader>b"] = { desc = require("astroui").get_icon("Tab", 1, true) .. "Buffers" },
        ["<Leader>bc"] = { function() Snacks.bufdelete.delete() end, desc = "Close this buffer" },
        ["<Leader>bd"] = { function() Snacks.bufdelete.delete() end, desc = "Close this buffer" },
        ["<Leader>bC"] = { function() Snacks.bufdelete.all() end, desc = "Close all buffers" },
        ["<Leader>bD"] = { function() Snacks.bufdelete.all() end, desc = "Close all buffers" },
        ["<Leader>bo"] = { function() Snacks.bufdelete.other() end, desc = "Close other buffers" },
        ["ycb"] = {
          function() vim.fn.setreg("+", get_current_branch()) end,
          desc = "Yank current branch",
        },
        ["<Leader>gi"] = {
          "<Cmd>norm ycb^Pa - <CR><Cmd>lua vim.api.nvim_feedkeys('a', 'n', false)<CR>",
          desc = "Insert current branch",
        },
        ["<Leader>uv"] = {
          function() require("tiny-inline-diagnostic").toggle() end,
          desc = "Toggle virtual text",
        },

        ["<Leader>ue"] = {
          function()
            local virtualedit = vim.opt.virtualedit:get() -- Get the current value as a list
            if vim.tbl_contains(virtualedit, "block") then
              vim.opt.virtualedit = { "all" }
              vim.notify "VirtualEdit set to: all"
            else
              vim.opt.virtualedit = { "block" }
              vim.notify "VirtualEdit set to: block"
            end
          end,
          desc = "Toggle virtual_text",
        },
      },
      i = {
        ["<C-M-q>"] = { "<cmd>bd<CR>", silent = true, desc = "Close current window" },
      },
      x = {
        ["<Leader>gh"] = { "<cmd>'<,'>DiffviewFileHistory<cr>", desc = "Open file history" },
      },
    },
    autocmds = {
      -- set up autocommand to choose the correct language server
      eslint_over_typescript_formatting = {
        {
          event = "LspAttach",
          callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local vtslsClient = client and client.name == "vtsls" and client
              or vim.lsp.get_clients({ name = "vtsls", bufnr = bufnr })[1]

            local eslintClient = client and client.name == "eslint" and client
              or vim.lsp.get_clients { name = "eslint", bufnr = bufnr }

            if eslintClient and vtslsClient then
              vtslsClient.server_capabilities.documentFormattingProvider = false
              vtslsClient.server_capabilities.documentRangeFormattingProvider = false

              map("n", { "grF", "<Leader>lF" }, function()
                vim.cmd "silent! VtsExec remove_unused"
                vim.cmd "silent! VtsExec remove_unused_imports"
                vim.cmd "silent! VtsExec organize_imports "
                vim.schedule(function() vim.cmd "silent! EslintFixAll" end)
              end, {
                desc = "Fix all issues from Eslint",
              })
            end
          end,
        },
      },

      vtsls_keymaps = {
        {
          event = "LspAttach",
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client or client.name ~= "vtsls" then return end
            local bufnr = args.buf

            map(
              "n",
              { "gD" },
              "<cmd>VtsExec goto_source_definition<CR>",
              { buffer = bufnr, desc = "Go to source definition" }
            )
            map(
              "n",
              { "grm", "<leader>lm" },
              "<cmd>VtsExec add_missing_imports<CR>",
              { buffer = bufnr, desc = "Add missing imports" }
            )
            map(
              "n",
              { "gro", "<leader>lo" },
              "<cmd>VtsExec organize_imports<CR>",
              { buffer = bufnr, desc = "Organize Imports" }
            )
            map(
              "n",
              { "grN", "<leader>lN", "<leader>lR" },
              "<cmd>VtsExec rename_file<CR>",
              { desc = "Rename File", buffer = bufnr }
            )
            map("n", { "gru", "<leader>lu" }, "<cmd>VtsExec remove_unused<CR>", { desc = "Remove unused" })

            vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
              local locations = command.arguments[3]
              local clt = vim.lsp.get_client_by_id(ctx.client_id)
              if clt == nil then return end

              if locations and #locations > 0 then
                local items = vim.lsp.util.locations_to_items(locations, clt.offset_encoding)
                vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
                vim.api.nvim_command "lopen"
              end
            end
          end,
        },
      },
    },
  },
}
