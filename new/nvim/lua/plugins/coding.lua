return {
  -- Toggle comments with gc and gcc
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    keys = {
      { "gc", nil },
      { "gcc", nil },
    },
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
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
        keymaps = { -- vim-surround style keymaps
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
      { "<leader>u", "<cmd>UndotreeToggle<CR>", mode = "n" },
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
          ["<tab>"] = cmp.config.disable,
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
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
          },
          completion = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
          },
        },
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    opts = {
      input_buffer_type = "dressing",
    },
  },
}
