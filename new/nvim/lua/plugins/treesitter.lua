return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
      { "{e", desc = "Swap previous", mode = "x" },
      { "}e", desc = "Swap next", mode = "x" },
      { "{e", desc = "Swap previous" },
      { "}e", desc = "Swap next" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
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
        swap = {
          enable = true,
          swap_previous = {
            ["{e"] = "@parameter.inner",
          },
          swap_next = {
            ["}e"] = "@parameter.inner",
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
    end,
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
    },
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
  },
}
