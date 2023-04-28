return {
  { "knubie/vim-kitty-navigator" },

  -- Jump anywhere in the document using hints
  {
    "phaazon/hop.nvim",
    config = true,
    lazy = false,
    keys = {
      {
        "<leader><leader>",
        function()
          require("hop").hint_words()
        end,
        desc = "Displays labels to jump anywhere",
        mode = { "n", "v" },
      },
    },
  },

  -- Inteligently chooses the next buffer
  { "echasnovski/mini.bufremove" },

  -- Utility to close buffers in bulk
  {
    "Asheq/close-buffers.vim",
    keys = {
      { "<leader>bc", "<cmd>Bdelete this<CR>", mode = "n", desc = "Close this buffer" },
      { "<leader>bC", "<cmd>Bdelete all<CR>", mode = "n", desc = "Close all buffers" },
      { "<leader>bo", "<cmd>Bdelete other<CR>", mode = "n", desc = "Close other buffers" },
      { "<leader>bh", "<cmd>Bdelete hidden<CR>", mode = "n", desc = "Close hidden buffers" },
      { "<leader>br", "<cmd>BdeleteByRegex<CR>", mode = "n", desc = "Close buffers by regex" },
    },
  },

  -- Extends textobject
  {
    "echasnovski/mini.ai",
    main = "mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      })
    end,
  },

  -- Mappings for e[ e] q[ q] l[ l], etc
  {
    "tummetott/unimpaired.nvim",
    config = true,
    keys = {
      { "[f", nil },
      { "]f", nil },
      { "[e", nil },
      { "]e", nil },
      { "[j", "<C-o>", mode = "n" },
      { "]j", "<C-i>", mode = "n" },
      { "[r", "<<", mode = "n" },
      { "]r", ">>", mode = "n" },
      { "[r", "<", mode = "v" },
      { "]r", ">", mode = "v" },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fb", "<cmd>Telescope buffers<CR>", mode = "n", desc = "Find by file name and path" },
      { "<leader>fc", "<cmd>Telescope colorscheme<CR>", mode = "n", desc = "Find Colorscheme" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", mode = "n", desc = "Search for files (respecting .gitignore)" },
      { "<leader>f<tab>", "<cmd>Telescope harpoon marks<CR>", mode = "n", desc = "Search through harpoon marks" },
      {
        "<leader>fF",
        "<cmd>Telescope find_files hidden=true no_ignore=true<CR>",
        desc = "Find by file name and path including hidden files",
        mode = "n",
      },
      {
        "<leader>ft",
        "<cmd>Telescope live_grep<CR>",
        mode = "n",
        desc = "Search for a string and get results live as you type",
      },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", mode = "n", desc = "Help" },
      { "<leader>fl", "<cmd>Telescope resume<CR>", mode = "n", desc = "Resume" },
      { "<leader>fj", "<cmd>Telescope jumplist<CR>", mode = "n", desc = "Lists Jumplist" },
      { "<leader>fn", "<cmd>Telescope notify<CR>", mode = "n", desc = "Lists notifications" },
      { "<leader>fm", "<cmd>Telescope man_pages<CR>", mode = "n", desc = "Find in Man Pages" },
      { "<leader>fr", "<cmd>Telescope oldfiles cwd_only=true<CR>", mode = "n", desc = "Recent File" },
      { "<leader>fR", "<cmd>Telescope registers<CR>", mode = "n", desc = "Registers" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", mode = "n", desc = "Keymaps" },
      { "<leader>fC", "<cmd>Telescope commands<CR>", mode = "n", desc = "Commands" },
      { "<leader>fq", "<cmd>Telescope quickfix<CR>", mode = "n", desc = "Quickfix" },
      { "<leader>fQ", "<cmd>Telescope quickfixhistory<CR>", mode = "n", desc = "Quickfix Hitory" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")
      return {
        defaults = vim.tbl_extend("keep", themes.get_ivy(), {
          file_sorter = require("telescope.sorters").get_fzf_sorter,
          path_display = { "truncate" },
          selection_caret = "\u{e0b1} ",
          prompt_prefix = "\u{e0b1} ",
          color_devicons = true,
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              --[[ ["<C-e>"] = require("user.nvim-tree").open_in_nvim_tree, ]]
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<c-x>"] = actions.delete_buffer,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = function(bufnr)
                actions.send_to_qflist(bufnr)
                vim.cmd("Telescope quickfix")
              end,
              ["<M-q>"] = function(bufnr)
                actions.send_selected_to_qflist(bufnr)
                vim.cmd("Telescope quickfix")
              end,
              ["<esc><esc>"] = actions.close,
            },
            n = {
              --[[ ["<C-e>"] = require("user.nvim-tree").open_in_nvim_tree, ]]
              ["<esc>"] = actions.close,
              ["<esc><esc>"] = actions.close,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.delete_buffer,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["q"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
            },
          },
        }),
        pickers = {
          buffers = {
            sort_mru = true,
          },
          oldfiles = {
            cwd_only = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  { "tom-anders/telescope-vim-bookmarks.nvim" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    config = function()
      require("telescope").load_extension("fzf")
    end,
    build = "make",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  {
    "MattesGroeger/vim-bookmarks",
    keys = {
      {
        "<leader>ma",
        "<cmd>silent BookmarkAnnotate<cr>",
        mode = "n",
        desc = "Annotate bookmark",
      },
      {
        "<leader>mc",
        "<cmd>silent BookmarkClear<cr>",
        mode = "n",
        desc = "Clear bookmark",
      },
      {
        "<leader>mm",
        "<cmd>silent BookmarkToggle<cr>",
        mode = "n",
        desc = "Toggle bookmark",
      },
      {
        "<leader>mj",
        "<cmd>silent BookmarkNext<cr>",
        mode = "n",
        desc = "Next bookmark",
      },
      {
        "<leader>mk",
        "<cmd>silent BookmarkPrev<cr>",
        mode = "n",
        desc = "Previous bookmark",
      },
      {
        "<leader>mf",
        "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
        mode = "n",
        desc = "List all bookmarks",
      },
      {
        "<leader>mx",
        "<cmd>BookmarkClearAll<cr>",
        mode = "n",
        desc = "Clear All",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("harpoon")
    end,
    keys = {
      { "<tab>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', mode = "n", desc = "Brings Harpoon UI" },
      {
        "<leader><tab>",
        '<cmd>lua require("harpoon.mark").add_file()<cr>',
        mode = "n",
        desc = "Send current file to Harpoon",
      },
    },
  },
}
