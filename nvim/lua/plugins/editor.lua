return {
  -- Toggle comments with gc and gcc
  { "vim-scripts/lastpos.vim" },
  { "andymass/vim-visput" },
  {
    "numToStr/Comment.nvim",
    main = "Comment",
    config = true,
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gc",
        ---Block-comment keymap
        block = "gb",
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },

      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },

  -- Provide repeat fn for other plugins
  { "tpope/vim-repeat" },

  -- Navigate, change and wrap text with surrounding characters
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          -- vim-surround style keymaps
          insert_line = "<C-g>S",
          normal = "s",
          normal_line = "S",
          visual = "s",
          visual_line = "S",
          delete = "ds",
          change = "cs",
        },
      })
    end,
  },

  -- Displays a tree
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", mode = "n", desc = "Toggles Undo Tree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  --snippet engine
  { "L3MON4D3/LuaSnip" },
  -- a bunch of snippets to use
  { "rafamadriz/friendly-snippets" },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path", -- path completions
      "hrsh7th/cmp-cmdline", -- cmdline completions
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-emoji",
      "zbirenbaum/copilot-cmp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local compare = require("cmp.config.compare")
      local icons = require("config.icons")
      local kind_icons = icons.kind

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
      vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

      require("luasnip/loaders/from_vscode").lazy_load()

      local check_backspace = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = {
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif check_backspace() then
              cmp.complete()
            else
              cmp.complete()
            end
          end, {
            "i",
            "s",
          }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<c-y>"] = cmp.mapping(
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),
            { "i", "c" }
          ),
          ["<CR>"] = cmp.mapping(
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),
            { "i" }
          ),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.config.disable,
          ["<c-q>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        },
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = kind_icons[vim_item.kind]

            if entry.source.name == "copilot" then
              vim_item.kind = icons.git.Octoface
              vim_item.kind_hl_group = "CmpItemKindCopilot"
            end

            if entry.source.name == "emoji" then
              vim_item.kind = icons.misc.Smiley
              vim_item.kind_hl_group = "CmpItemKindEmoji"
            end

            if entry.source.name == "crates" then
              vim_item.kind = icons.misc.Package
              vim_item.kind_hl_group = "CmpItemKindCrate"
            end

            -- NOTE: order matters
            vim_item.menu = ({
              nvim_lsp = "[LSP] ",
              nvim_lua = "[Lua] ",
              luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              path = "[Path]",
              emoji = "[Emoji]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = {
          { name = "crates" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "copilot" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
          { name = "nvim_lsp_signature_help" },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,
            require("copilot_cmp.comparators").score,
            compare.offset,
            compare.exact,
            -- compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            -- compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,

            -- require("copilot_cmp.comparators").prioritize,
            -- require("copilot_cmp.comparators").score,
          },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },
        experimental = {
          --@type cmp.ExperimentalConfig
          ghost_text = {
            hl_group = "Comment",
          },
        },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "List references using Trouble" },
      {
        "[D",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]D",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    keys = {
      {
        "<Tab>",
        function()
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
          end
        end,
        mode = "i",
        { desc = "Super Tab" },
      },
    },
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = "<Up>",
          prev = "<Down>",
          dismiss = "<Left>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 16.x
      server_opts_overrides = {},
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        callback = function()
          require("copilot.suggestion").toggle_auto_trigger()
        end,
      })
    end,
  },
  { "nacro90/numb.nvim", config = true, event = "CmdlineEnter" },
  { "echasnovski/mini.pairs", main = "mini.pairs", event = "InsertEnter", config = true },
  { "folke/neodev.nvim" },
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        mode = "n",
        desc = "Run nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        mode = "n",
        desc = "Runs current file",
      },
      {
        "<leader>tt",
        function()
          require("neotest").summary.toggle()
        end,
        mode = "n",
        desc = "Toggles NeoTest Summary",
      },
      {
        "<leader>tw",
        function()
          require("neotest").run.run({ jestCommand = "pnpm test -- --watch " })
        end,
        mode = "n",
        desc = "Runs in nearst test watch mode",
      },

      { "<leader>ta", '<cmd>lua require("neotest").run.attach()<CR>', mode = "n", desc = "Attaches the current run" },
      {
        "<leader>to",
        '<cmd>lua require("neotest").output.open()<CR>',
        mode = "n",
        desc = "Shows the output",
      },
      {
        "<leader>tO",
        '<cmd>lua require("neotest").output_panel.toggle()<CR>',
        mode = "n",
        desc = "Shows the output panel",
      },
      {
        "[N",
        '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>',
        mode = "n",
        desc = "Go to the previous failed test",
      },
      {
        "[n",
        '<cmd>lua require("neotest").jump.prev()<CR>',
        mode = "n",
        desc = "Go to the previous test",
      },
      {
        "]N",
        '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>',
        mode = "n",
        desc = "Go to the next failed test",
      },
      { "]n", '<cmd>lua require("neotest").jump.next()<CR>', mode = "n", desc = "Go to the next test" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      { "haydenmeade/neotest-jest", lazy = true },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-jest")({
            jestCommand = "pnpm test -- ",
          }),
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
        output_panel = {
          enabled = true,
          open = "vsplit | vertical resize 50",
        },
        summary = {
          open = "botright vsplit | vertical resize 40",
          mappings = {
            expand_all = "<space>",
          },
        },
      }
    end,
  },
  {
    "smjonas/live-command.nvim",
    -- live-command supports semantic versioning via tags
    -- tag = "1.*",
    opts = {
      commands = {
        Norm = { cmd = "norm" },
      },
    },
  },
}
