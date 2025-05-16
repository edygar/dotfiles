return {
  -- Toggle comments with gc and gcc
  { "vim-scripts/lastpos.vim" },
  { "andymass/vim-visput" },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    main = "ts_context_commentstring",
    opts = function()
      vim.g.skip_ts_context_commentstring_module = true
      return {
        enable_autocmd = false,
      }
    end,
  },

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

      -- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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
  -- { "L3MON4D3/LuaSnip" },

  -- a bunch of snippets to use
  { "rafamadriz/friendly-snippets" },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
  },
  {
    "ggml-org/llama.vim",
    enabled = true,
    init = function()
      vim.g.llama_config = {
        ["endpoint"] = "http://127.0.0.1:8012/infill",
        ["api_key"] = "",
        ["n_prefix"] = 256,
        ["n_suffix"] = 64,
        ["n_predict"] = 128,
        ["t_max_prompt_ms"] = 500,
        ["t_max_predict_ms"] = 500,
        ["show_info"] = 2,
        ["auto_fim"] = true,
        ["max_line_suffix"] = 8,
        ["max_cache_keys"] = 250,
        ["ring_n_chunks"] = 16,
        ["ring_chunk_size"] = 64,
        ["ring_scope"] = 1024,
        ["ring_update_ms"] = 1000,
      }
    end,
  },
  {
    "kiddos/gemini.nvim",
    enabled = false,
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- "github/copilot.vim",
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path", -- path completions
      "hrsh7th/cmp-cmdline", -- cmdline completions
      -- "saadparwaiz1/cmp_luasnip", -- snippet completions
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      -- local luasnip = require("luasnip")
      local compare = require("cmp.config.compare")
      local icons = require("config.icons")
      local kind_icons = icons.kind

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
      vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

      -- require("luasnip/loaders/from_vscode").lazy_load()

      local check_backspace = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        mapping = {
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            elseif check_backspace() then
              cmp.complete()
            else
              cmp.complete()
            end
          end, {
            "i",
            "s",
          }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
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
          ["<C-Space>"] = cmp.mapping({
            i = cmp.mapping.complete(),
            c = function(
              _ --[[fallback]]
            )
              if cmp.visible() then
                if not cmp.confirm({ select = true }) then
                  return
                end
              else
                cmp.complete()
              end
            end,
          }),
          ["<Tab>"] = cmp.config.disable,
          ["<C-q>"] = cmp.mapping.confirm({
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
              -- luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              path = "[Path]",
              emoji = "[Emoji]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = {
          { name = "codeium" },
          { name = "crates" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
          { name = "emoji" },
          { name = "nvim_lsp_signature_help" },
        },
        sorting = {
          -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
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
          -- I like the new menu better! Nice work hrsh7th
          native_menu = false,

          -- Let's play with this for a day or two
          ghost_text = false,
        },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    enabled = true,
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
    main = "live-command",
    -- live-command supports semantic versioning via tags
    -- tag = "1.*",
    opts = {
      commands = {
        Norm = { cmd = "norm" },
      },
    },
  },
  { "arthurxavierx/vim-caser" },
}
