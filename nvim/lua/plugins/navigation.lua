return {
  { "knubie/vim-kitty-navigator" },
  {
    "kyazdani42/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeClose",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeOpen<cr>", mode = "n", desc = "Toggles files tree" },
    },
    opts = function()
      -- file explorer
      local status_ok, nvim_tree = pcall(require, "nvim-tree")
      if not status_ok then
        return
      end

      local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
      if not config_status_ok then
        return
      end

      local icons = require("config.icons")

      return {
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeClose<cr>", opts("Close nvim tree"))

          --
          --[[ Window navigation ]]
          --
          vim.keymap.set("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", opts("Go to lower window"))
          vim.keymap.set("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", opts("Go to left window"))
          vim.keymap.set("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", opts("Go to upper window"))
          vim.keymap.set("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", opts("Go to right window"))

          --
          --[[ Moving around ]]
          --
          vim.keymap.set("n", "H", api.node.navigate.parent, opts("Parent Directory"))
          vim.keymap.set("n", "J", api.node.navigate.sibling.next, opts("Next Sibling"))
          vim.keymap.set("n", "K", api.node.navigate.sibling.prev, opts("Previous Sibling"))
          vim.keymap.set("n", "L", api.node.open.edit, opts("Open"))

          -- Git
          vim.keymap.set("n", "[g", api.node.navigate.git.prev, opts("Prev Git"))
          vim.keymap.set("n", "]g", api.node.navigate.git.next, opts("Next Git"))

          -- Diagnostic
          vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
          vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))

          --
          --[[ Opening ]]
          --
          vim.keymap.set("n", "-", api.tree.change_root_to_node, opts("CD"))
          vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
          vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
          vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
          vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
          vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))

          vim.keymap.set("n", "<C-e>", api.tree.expand_all, opts("Expand All"))
          vim.keymap.set("n", "<C-c>", api.tree.collapse_all, opts("Collapse All"))

          --
          --[[ Visibility filter ]]
          --
          vim.keymap.set("n", "oh", api.tree.toggle_hidden_filter, opts("Toggle Hidden files"))
          vim.keymap.set("n", "ogi", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
          vim.keymap.set("n", "ob", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
          vim.keymap.set("n", "ogc", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))

          vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
          vim.keymap.set("n", "<esc><esc>", api.live_filter.clear, opts("Clean Filter"))
          vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))

          --
          --[[ Managing files ]]
          --
          vim.keymap.set("n", "<C-i>", api.node.show_info_popup, opts("Info"))
          vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
          vim.keymap.set("n", "a", api.fs.create, opts("Create"))
          vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))

          -- Copy, cutting and pasting
          vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
          vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
          vim.keymap.set("n", "v", api.fs.paste, opts("Paste"))
          vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
          vim.keymap.set("n", "ycr", api.fs.copy.relative_path, opts("Copy Relative Path"))
          vim.keymap.set("n", "ycf", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

          --
          --[[ Misc ]]
          --
          vim.keymap.set("n", ":", api.node.run.cmd, opts("Run Command"))
          vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
          --

          -- -- Default mappings. Feel free to modify or remove as you wish.
          -- --
          -- -- BEGIN_DEFAULT_ON_ATTACH
          vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
          vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

          vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
          vim.keymap.set("n", "q", api.tree.close, opts("Close"))
          vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
          vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
          vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
          vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
          -- -- END_DEFAULT_ON_ATTACH
          --
          -- -- Mappings migrated from view.mappings.list
          -- --
          -- -- You will need to insert "your code goes here" for any mappings with a custom action_cb
          vim.keymap.set("n", "<Right>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
          vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts("Close Directory"))
          vim.keymap.set("n", "<c-v>", api.node.open.vertical, opts("Open: Vertical Split"))
          vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
          vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        end,
        hijack_directories = {
          enable = true,
        },
        disable_netrw = true,
        hijack_netrw = true,
        filters = {
          custom = { ".git" },
          exclude = { ".gitignore" },
        },
        -- auto_close = true,
        -- open_on_tab = false,
        -- hijack_cursor = false,
        update_cwd = false,
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          highlight_opened_files = "none",
          root_folder_modifier = ":t",
          indent_markers = {
            enable = false,
            icons = {
              corner = "└ ",
              edge = "│ ",
              none = "  ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_open = icons.ui.ArrowOpen,
                arrow_closed = icons.ui.ArrowClosed,
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "",
                staged = "S",
                unmerged = "",
                renamed = "➜",
                untracked = "U",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        diagnostics = {
          enable = true,
          icons = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Information,
            warning = icons.diagnostics.Warning,
            error = icons.diagnostics.Error,
          },
        },
        update_focused_file = {
          enable = true,
          update_cwd = false,
          ignore_list = {},
        },
        -- system_open = {
        --   cmd = nil,
        --   args = {},
        -- },
        -- filters = {
        --   dotfiles = false,
        --   custom = {},
        -- },
        git = {
          enable = true,
          ignore = true,
          timeout = 500,
        },
        view = {
          width = 30,
          hide_root_folder = false,
          side = "right",
          number = false,
          relativenumber = false,
        },
      }
    end,
  },

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

  -- Mappings for e[ e] q[ q] l[ l], etc
  {
    "tummetott/unimpaired.nvim",
    config = true,
    keys = {
      { "[f", nil, mode = "n" },
      { "]f", nil, mode = "n" },
      { "[e", nil },
      { "]e", nil },
      { "[j", "<C-o>", mode = "n" },
      { "]j", "<C-i>", mode = "n" },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "g=", "<cmd>Telescope spell_suggest<cr>", mode = "n", desc = "Spell suggest" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", mode = "n", desc = "Find by file name and path" },
      { "<leader>fc", "<cmd>Telescope colorscheme<CR>", mode = "n", desc = "Find Colorscheme" },
      {
        "<leader>ff",
        "<cmd>Telescope find_files<CR>",
        mode = "n",
        desc = "Search for files (respecting .gitignore)",
      },
      {
        "<leader>f<tab>",
        "<cmd>Telescope harpoon marks<CR>",
        mode = "n",
        desc = "Search through harpoon marks",
      },
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
      {
        "<leader>fT",
        "<cmd>Telescope live_grep hidden=true no_ignore=true<CR>",
        mode = "n",
        desc = "Search for a string and get results live as you type",
      },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", mode = "n", desc = "Help" },
      { "<leader>fl", "<cmd>Telescope resume<CR>", mode = "n", desc = "Resume" },
      { "<leader>fj", "<cmd>Telescope jumplist<CR>", mode = "n", desc = "Lists Jumplist" },
      { "<leader>fn", "<cmd>Telescope notify<CR>", mode = "n", desc = "Lists notifications" },
      { "<leader>fM", "<cmd>Telescope man_pages<CR>", mode = "n", desc = "Find in Man Pages" },
      { "<leader>fr", "<cmd>Telescope oldfiles cwd_only=true<CR>", mode = "n", desc = "Recent File" },
      { "<leader>fR", "<cmd>Telescope registers<CR>", mode = "n", desc = "Registers" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", mode = "n", desc = "Keymaps" },
      { "<leader>fC", "<cmd>Telescope commands<CR>", mode = "n", desc = "Commands" },
      { "<leader>fq", "<cmd>Telescope quickfix<CR>", mode = "n", desc = "Quickfix" },
      { "<leader>fQ", "<cmd>Telescope quickfixhistory<CR>", mode = "n", desc = "Quickfix Hitory" },
      {
        "<leader>fd",
        "<cmd>Telescope diagnostics<CR>",
        mode = "n",
        desc = "List all diagnostic entries",
      },
      {
        "<leader>fs",
        "<cmd>Telescope lsp_document_symbols<CR>",
        mode = "n",
        desc = "List all LSP Symbols for the current document",
      },

      {
        "<leader>fS",
        "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
        mode = "n",
        desc = "Search through all LSP Symbols for the current workspace",
      },
      { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
      { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local layoutActions = require("telescope.actions.layout")
      local themes = require("telescope.themes")
      local action_state = require("telescope.actions.state")

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
              ["<C-e>"] = function(prompt_bufnr)
                vim.cmd("NvimTreeClose")
                vim.cmd("NvimTreeOpen")
                actions.select_default(prompt_bufnr)
              end,
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
              ["<A-p>"] = layoutActions.toggle_preview,
              ["<C-S-p>"] = layoutActions.toggle_preview,
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
              ["tt"] = require("trouble.providers.telescope").open_with_trouble,
              ["<C-e>"] = function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local Path = require("plenary.path")
                local actions = require("telescope.actions")

                local entry = action_state.get_selected_entry()[1]
                local entry_path = Path:new(entry):parent():absolute()
                actions._close(prompt_bufnr, true)
                entry_path = Path:new(entry):parent():absolute()
                entry_path = entry_path:gsub("\\", "\\\\")

                vim.cmd("NvimTreeClose")
                vim.cmd("NvimTreeOpen " .. entry_path)

                local file_name = nil
                for s in string.gmatch(entry, "[^/]+") do
                  file_name = s
                end

                vim.cmd("/" .. file_name)
              end,
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
              ["<M-p>"] = layoutActions.toggle_preview,
              ["<C-S-p>"] = layoutActions.toggle_preview,
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
        "<leader>fm",
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
    opts = {
      menu = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
      },
    },
    config = function(_, opts)
      require("harpoon").setup(opts)
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
  {
    "stevearc/qf_helper.nvim",
    config = true,
    keys = {
      -- use <C-N> and <C-P> for next/prev.
      { "]q", "<CMD>QNext<CR>", mode = "n", desc = "Previous quickfix entry" },
      { "[q", "<CMD>QPrev<CR>", mode = "n", desc = "Next quickfix entry" },
      -- toggle the quickfix open/closed without jumping to it
      { "<leader>q", "<CMD>QFToggle<CR>", mode = "n", desc = "Toggles Quickfix list window" },
      { "<leader>l", "<CMD>LLToggle<CR>", mode = "n", desc = "Toggles location list window" },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>/",
        '<cmd>lua require("spectre").open()<CR>',
        mode = "n",
        desc = "Open Spectre",
      },
      {
        "<leader>/",
        '<esc><cmd>lua require("spectre").open_visual()<CR>',
        mode = "v",
        desc = "Search current selection",
      },
      {
        "<leader>?",
        '<cmd>lua require("spectre").open_file_search()<CR>',
        mode = "n",
        desc = "Search on current file",
      },
    },
    opts = {
      is_insert_mode = true,
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
