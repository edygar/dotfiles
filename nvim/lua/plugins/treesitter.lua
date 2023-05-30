return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "nvim-treesitter/playground" },
      { "windwp/nvim-ts-autotag" },
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
      { "[r", desc = "Swap previous", mode = { "n", "x" } },
      { "]r", desc = "Swap next", mode = { "n", "x" } },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      playground = {
        enable = true,
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      autotag = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = true },
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "prisma",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            ["is"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
        },
        swap = {
          enable = true,
          swap_previous = {
            ["[r"] = "@parameter.inner",
          },
          swap_next = {
            ["]r"] = "@parameter.inner",
          },
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
          spacing = 5,
          severity_limit = "Warning",
        },
        update_in_insert = true,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "ziontee113/syntax-tree-surfer",
    keys = {
      {
        "vv",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Select current Node",
        mode = "n",
        noremap = true,
        silent = true,
        nowait = true,
      },

      -- Select Nodes in Visual Mode
      {
        "<C-A-k>",
        "<cmd>STSSelectPrevSiblingNode<cr>",
        desc = "Navigate to next node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-j>",
        "<cmd>STSSelectNextSiblingNode<cr>",
        desc = "Navigate to previous node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-l>",
        "<cmd>STSSelectChildNode<cr>",
        desc = "Navigate to inner",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-h>",
        "<cmd>STSSelectParentNode<cr>",
        desc = "Navigate to outer",
        mode = "x",
        noremap = true,
        silent = true,
      },

      {
        "<Up>",
        "<cmd>STSSelectPrevSiblingNode<cr>",
        desc = "Navigate to next node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<Down>",
        "<cmd>STSSelectNextSiblingNode<cr>",
        desc = "Navigate to previous node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<Right>",
        "<cmd>STSSelectChildNode<cr>",
        desc = "Navigate to inner",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<Left>",
        "<cmd>STSSelectParentNode<cr>",
        desc = "Navigate to outer",
        mode = "x",
        noremap = true,
        silent = true,
      },

      -- Normal mode
      {
        "<C-A-k>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to next node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-j>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to previous node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-l>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to inner",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-h>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to outer",
        mode = "n",
        noremap = true,
        silent = true,
      },

      {
        "<Up>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to next node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<Down>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to previous node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<Left>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to outer",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<Right>",
        "<cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to inner",
        mode = "n",
        noremap = true,
        silent = true,
      },

      -- Swap nodes
      {
        "[E",
        function()
          vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
          return "g@l"
        end,
        mode = "n",
        silent = true,
        expr = true,
      },

      {
        "]E",
        function()
          vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
          return "g@l"
        end,
        mode = "n",
        silent = true,
        expr = true,
      },

      -- Swapping Nodes in Visual Mode
      { "]E", "<cmd>STSSwapPrevVisual<cr>", mode = "x", desc = "Move selected not upwards" },
      { "[E", "<cmd>STSSwapNextVisual<cr>", mode = "x", desc = "Move selected not downwards" },
    },
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = true,
    keys = {
      { "<leader>otc", "<cmd>TSContextToggle<cr>", mode = "n", desc = "Toggle Treesitter Context" },
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
      {
        "<leader>rr",
        ":lua require('refactoring').select_refactor()<CR>",
        mode = "v",
      },
    },
  },
}
