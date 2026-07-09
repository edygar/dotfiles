local get_current_branch = function()
  local ok, branch = pcall(vim.fn.system, "git branch --show-current")
  if not ok then return nil end
  if vim.v.shell_error ~= 0 then return nil end
  return vim.trim(branch)
end

local function map(mode, keys, fn, opts)
  for _, key in ipairs(keys) do
    vim.keymap.set(mode, key, fn, opts)
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    on_keys = {
      auto_hlsearch = {
        function(char)
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end,
      },
    },

    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },

    diagnostics = {
      virtual_text = true,
      underline = true,
    },

    options = {
      opt = {
        autowrite = true,
        backup = false,
        clipboard = "unnamedplus",
        cmdheight = 1,
        colorcolumn = "120",
        completeopt = { "menu", "menuone", "noselect" },
        conceallevel = 3,
        confirm = true,
        cursorline = true,
        cursorlineopt = "both",
        expandtab = true,
        fileencoding = "utf-8",
        foldenable = false,
        foldmethod = "indent",
        formatoptions = "jcroqlnt",
        grepformat = "%f:%l:%c:%m",
        grepprg = "rg --vimgrep",
        hlsearch = true,
        ignorecase = true,
        inccommand = "nosplit",
        laststatus = 3,
        list = true,
        listchars = { tab = "> ", trail = "·", nbsp = "·" },
        mouse = "a",
        number = false,
        numberwidth = 4,
        pumblend = 10,
        pumheight = 10,
        relativenumber = false,
        ruler = false,
        scrolloff = 8,
        sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
        shiftround = true,
        shiftwidth = 2,
        showcmd = false,
        showmode = false,
        showtabline = 1,
        sidescrolloff = 8,
        signcolumn = "yes",
        smartcase = true,
        smartindent = true,
        spell = true,
        spelllang = { "en" },
        splitbelow = true,
        splitright = true,
        swapfile = false,
        tabstop = 2,
        termguicolors = true,
        timeoutlen = 1000,
        undofile = true,
        undolevels = 10000,
        updatetime = 200,
        wildmode = "longest:full,full",
        winminwidth = 5,
        wrap = false,
        writebackup = false,
        statuscolumn = "%s%=%{v:relnum?v:relnum:''} │ %4{v:lnum} ",
      },
    },

    mappings = {
      n = {
        ["<Leader>ww"] = { "<cmd>w<CR>", desc = "Write current file" },
        ["<Leader>wq"] = { "<cmd>wq<CR>", desc = "Write and quit" },
        ["<Leader>wa"] = { "<cmd>wa<CR>", desc = "Write all" },
        ["<Leader>fj"] = { "<cmd>lua Snacks.picker.jumps()<CR>", desc = "Lists Jumplist" },
        ["[j"] = { "<C-o>" },
        ["]j"] = { "<C-i>" },
        ["<Leader>fy"] = {
          function()
            local clipboard = vim.fn.getreg "+"
            local path = vim.trim(clipboard)
            if path == "" then return end
            local components = {}
            for component in string.gmatch(path, "[^/]+") do
              table.insert(components, component)
            end
            if #components == 0 then return end
            local best_search = nil
            local best_count = 0
            for i = #components, 1, -1 do
              local search_parts = {}
              for j = i, #components do
                table.insert(search_parts, components[j])
              end
              local search_term = "**/" .. table.concat(search_parts, "/")
              local count = 0
              local fd_cmd = string.format("fd -tf -p -g '%s' 2>/dev/null", search_term)
              local handle = io.popen(fd_cmd)
              local file = nil
              if handle then
                for line in handle:lines() do
                  file = line
                  count = count + 1
                end
                handle:close()
              end
              if count == 1 then
                vim.cmd("e " .. file)
                return
              end
              if count > 0 then
                best_search = search_term
                best_count = count
              end
            end
            if best_search then
              Snacks.picker.files { pattern = best_search }
            else
              local filename = components[#components]
              Snacks.picker.files { pattern = filename }
            end
          end,
          silent = true,
          desc = "Search clipboard file",
        },
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
        ["<Leader>h"] = { "<Cmd>noh<CR>", desc = "No highlight" },
        ["te"] = { "<Cmd>tabedit %<CR>", desc = "New tab" },
        ["tt"] = { "<Cmd>tabnew<CR>", desc = "New tab" },
        ["tj"] = { "<Cmd>tabprevious<CR>", desc = "Previous tab" },
        ["tk"] = { "<Cmd>tabnext<CR>", desc = "Next tab" },
        ["tc"] = { "<Cmd>tabclose<CR>", desc = "Close tab" },
        ["<Leader>ln"] = { "<Cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename symbol" },
        ["<C-S-l>"] = { [[<cmd>vertical resize +5<CR>]], desc = "Make window bigger vertically" },
        ["<C-S-h>"] = { [[<cmd>vertical resize -5<CR>]], desc = "Make window smaller vertically" },
        ["<C-S-j>"] = { [[<cmd>horizontal resize +2<CR>]], desc = "Make window bigger horizontally" },
        ["<C-S-k>"] = { [[<cmd>horizontal resize -2<CR>]], desc = "Make window smaller horizontally" },
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
        ["<Leader>uv"] = {
          function() require("tiny-inline-diagnostic").toggle() end,
          desc = "Toggle virtual text",
        },
        ["<Leader>ue"] = {
          function()
            local virtualedit = vim.opt.virtualedit:get()
            if vim.tbl_contains(virtualedit, "block") then
              vim.opt.virtualedit = { "all" }
              vim.notify "VirtualEdit set to: all"
            else
              vim.opt.virtualedit = { "block" }
              vim.notify "VirtualEdit set to: block"
            end
          end,
          desc = "Toggle virtual edit",
        },
        ["<Leader>to"] = {
          function() require("astrocore").toggle_term_cmd { cmd = "opencode", direction = "float" } end,
          desc = "ToggleTerm opencode",
        },
        ["<C-j>"] = { "<cmd>KittyNavigateDown<cr>", desc = "Go to lower window" },
        ["<C-h>"] = { "<cmd>KittyNavigateLeft<cr>", desc = "Go to left window" },
        ["<C-k>"] = { "<cmd>KittyNavigateUp<cr>", desc = "Go to upper window" },
        ["<C-l>"] = { "<cmd>KittyNavigateRight<cr>", desc = "Go to right window" },
        ["<Leader>gB"] = {
          function() package.loaded.gitsigns.blame_line { full = true } end,
          desc = "Opens the Hunk Preview in a popup",
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

            map("n", { "gD" }, "<cmd>VtsExec goto_source_definition<CR>", { buffer = bufnr, desc = "Go to source definition" })
            map("n", { "grm", "<leader>lm" }, "<cmd>VtsExec add_missing_imports<CR>", { buffer = bufnr, desc = "Add missing imports" })
            map("n", { "gro", "<leader>lo" }, "<cmd>VtsExec organize_imports<CR>", { buffer = bufnr, desc = "Organize Imports" })
            map("n", { "grN", "<leader>lN", "<leader>lR" }, "<cmd>VtsExec rename_file<CR>", { desc = "Rename File", buffer = bufnr })
            map("n", { "gru", "<leader>lu" }, "<cmd>VtsExec remove_unused<CR>", { desc = "Remove unused", buffer = bufnr })

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
