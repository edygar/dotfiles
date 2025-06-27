-- Youcan also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:
local IS_KITTY_SCROLLBACK = false
---@type LazySpec
return {
  {
    "mbbill/undotree",
    keys = {
      { "<leader>U", "<Cmd>UndotreeToggle<CR>", mode = "n", desc = "Toggles Undo Tree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "lunarvim/onedarker.nvim",
    config = function()
      local palette = require "onedarker.palette"
      local hl = vim.api.nvim_set_hl

      palette.bg = "NONE"
      palette.alt_bg = "NONE"
      palette.hint = palette.green

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          if vim.g.colors_name ~= "onedarker" then return end

          hl(0, "DropBarIconUISeparator", { fg = palette.gray })
          hl(0, "TreesitterContextBottom", { underline = true, sp = palette.gray })
          hl(0, "NonText", { fg = palette.gray, bg = palette.alt_bg })
          hl(0, "FoldColumn", { fg = palette.gray, bg = palette.alt_bg })
          hl(0, "SpellBad", { fg = "NONE", bg = "NONE", sp = palette.hint, undercurl = true })
          hl(0, "WhichKeyFloat", { fg = "NONE", bg = "NONE" })
          hl(0, "TelescopeNormal", { fg = palette.fg, bg = palette.bg })
          hl(0, "Whitespace", { fg = palette.gray, bg = palette.bg })
          hl(0, "GitSignsCurrentLineBlame", { fg = palette.gray })
          hl(0, "DiffviewDiffAddAsDelete", { bg = "#431313" })
          hl(0, "DiffDelete", { bg = "#431313" })
          hl(0, "DiffviewDiffDelete", { bg = "#431313" })
          hl(0, "DiffAdd", { bg = "#142a03" })
          hl(0, "DiffChange", { bg = "#3B3307" })
          hl(0, "DiffText", { bg = "#4D520D" })
          hl(0, "AlphaHeader", { fg = palette.green })

          hl(0, "WinBar", { bg = palette.bg })
          hl(0, "WinBarNC", { bg = palette.bg })

          -- hl(0, "CmpItemKindCody", { fg = palette.red })
          hl(0, "llama_hl_hint", { fg = palette.gray, ctermfg = 209 })
          hl(0, "llama_hl_info", { fg = palette.light_gray, ctermfg = 119 })

          hl(0, "SnacksIndent", { fg = palette.gray })
          hl(0, "SnacksIndentScope", { fg = palette.light_gray })
        end,
      })
      vim.cmd "colorscheme onedarker"
    end,
  },
  {
    "phaazon/hop.nvim",
    config = true,
    lazy = false,
    keys = {
      {
        "<leader><leader>",
        function() require("hop").hint_words() end,
        desc = "Displays labels to jump anywhere",
        mode = { "n", "v" },
      },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      {
        "junegunn/fzf.vim",
      },
    },
  },
  {
    "Juksuu/worktrees.nvim",
    lazy = false,
    keys = {
      {
        "<Leader>gw",
        function()
          require("snacks").picker.worktrees {
            actions = {
              delete_worktree == function(_, item)
                if item == nil then return end
                print(vim.inspect(item))
              end,
            },
            win = {
              input = {
                keys = {
                  ["<c-x>"] = { "delete_worktree", mode = { "n", "i" }, desc = "Delete worktree" },
                },
              },

              list = {
                keys = {
                  ["<c-x>"] = { "delete_worktree", mode = { "n", "i" }, desc = "Delete worktree" },
                },
              },
            },
          }
        end,
        desc = "Change git Worktree",
        mode = { "n" },
      },
      {
        "<Leader>gW",
        function() require("snacks").picker.worktrees_new() end,
        desc = "Create git Worktree",
        mode = { "n" },
      },
    },
    opts = {},
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    opts = {
      {
        callbacks = {
          after_launch = function()
            -- Define mappings for your *main Neovim instance* (already correct)
            vim.keymap.set("n", "<leader>q", "<Plug>(KsbQuitAll)", { buffer = true, silent = true }) -- quit kitty-scrollback.nvim with Esc key
            vim.keymap.set("n", "q", "<cmd>wqa!<cr>", { buffer = true, silent = true }) -- quit kitty-scrollback.nvim with Esc key

            IS_KITTY_SCROLLBACK = true
          end,
        },
        keymaps_enabled = true,
        paste_window = {
          yank_register_enabled = true,
        },
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts) opts.winbar = nil end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local highlight = {
        "CursorColumn",
        "Whitespace",
      }
      return {
        -- char = "▏",
        indent = { char = "▏" },
        -- whitespace = {
        --   highlight = highlight,
        --   remove_blankline_trail = true,
        -- },
        exclude = {
          filetypes = {
            "",
            "neotest-summary",
            "Cybu",
            "DressingSelect",
            "Jaq",
            "NvimTree",
            "Outline",
            "Trouble",
            "aerial",
            "alpha",
            "checkhealth",
            "dap-repl",
            "dap-terminal",
            "dapui_breakpoints",
            "dapui_console",
            "dapui_scopes",
            "dapui_stacks",
            "dapui_watches",
            "dashboard",
            "fugitive",
            "gitcommit",
            "harpoon",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "minpacprgs",
            "neo-tree",
            "neogitstatus",
            "nofile",
            "packer",
            "qf",
            "spectre_panel",
            "startify",
            "toggleterm",
            "undotree",
            "whichkey",
          },
          buftypes = {
            "BqfPreview",
            "Cybu",
            "DressingSelect",
            "Jaq",
            "NvimTree",
            "Outline",
            "Trouble",
            "aerial",
            "alpha",
            "checkhealth",
            "dap-repl",
            "dap-terminal",
            "dapui_breakpoints",
            "dapui_console",
            "dapui_scopes",
            "dapui_stacks",
            "dapui_watches",
            "dashboard",
            "fugitive",
            "gitcommit",
            "harpoon",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "minpacprgs",
            "neo-tree",
            "neogitstatus",
            "nofile",
            "neotest-summary",
            "packer",
            "prompt",
            "qf",
            "quickfix",
            "spectre_panel",
            "startify",
            "terminal",
            "toggleterm",
            "undotree",
            "whichkey",
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = true,
    keys = {
      { "<leader>utc", "<Cmd>TSContext toggle<cr>", mode = "n", desc = "Toggle Treesitter Context" },
    },
  },
  {
    "yioneko/nvim-vtsls",
    init = function()
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config, optional but recommended
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    opts = {
      window = {
        position = "right",
      },
    },
  },
  {
    "olrtg/nvim-emmet",
    config = function() vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation) end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
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
      }
    end,
  },
  {
    "smjonas/live-command.nvim",
    opts = {
      commands = {
        Norm = { cmd = "norm" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec", "disable.ft", "disable.bt" },
    opts = function(_, opts)
      if not opts.icons then opts.icons = {} end
      opts.win = {
        no_overlap = true,
        border = "single", -- none, single, double, shadow
        -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        bo = {},
        wo = {
          winblend = 10,
        },
      }

      opts.layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      }

      opts.icons.group = ""
      opts.icons.rules = false
      opts.icons.separator = "-"
      if vim.g.icons_enabled == false then
        opts.icons.breadcrumb = ">"
        opts.icons.group = "+"
        opts.icons.keys = {
          Up = "Up",
          Down = "Down",
          Left = "Left",
          Right = "Right",
          C = "Ctrl+",
          M = "Alt+",
          D = "Cmd+",
          S = "Shift+",
          CR = "Enter",
          Esc = "Esc",
          ScrollWheelDown = "ScrollDown",
          ScrollWheelUp = "ScrollUp",
          NL = "Enter",
          BS = "Backspace",
          Space = "Space",
          Tab = "Tab",
          F1 = "F1",
          F2 = "F2",
          F3 = "F3",
          F4 = "F4",
          F5 = "F5",
          F6 = "F6",
          F7 = "F7",
          F8 = "F8",
          F9 = "F9",
          F10 = "F10",
          F11 = "F11",
          F12 = "F12",
        }
      end
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    lazy = false,
    priority = 100,
    keys = {
      {
        "vv",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Select current Node",
        mode = "n",
        noremap = true,
        silent = true,
        nowait = true,
      },

      -- Select Nodes in Visual Mode
      {
        "<C-A-k>",
        "<Cmd>STSSelectPrevSiblingNode<cr>",
        desc = "Navigate to next node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-j>",
        "<Cmd>STSSelectNextSiblingNode<cr>",
        desc = "Navigate to previous node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-l>",
        "<Cmd>STSSelectChildNode<cr>",
        desc = "Navigate to inner",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-h>",
        "<Cmd>STSSelectParentNode<cr>",
        desc = "Navigate to outer",
        mode = "x",
        noremap = true,
        silent = true,
      },

      {
        "<Up>",
        "<Cmd>STSSelectPrevSiblingNode<cr>",
        desc = "Navigate to next node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<Down>",
        "<Cmd>STSSelectNextSiblingNode<cr>",
        desc = "Navigate to previous node",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<Right>",
        "<Cmd>STSSelectChildNode<cr>",
        desc = "Navigate to inner",
        mode = "x",
        noremap = true,
        silent = true,
      },
      {
        "<Left>",
        "<Cmd>STSSelectParentNode<cr>",
        desc = "Navigate to outer",
        mode = "x",
        noremap = true,
        silent = true,
      },

      -- Normal mode
      {
        "<C-A-k>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to next node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-j>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to previous node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-l>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to inner",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<C-A-h>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to outer",
        mode = "n",
        noremap = true,
        silent = true,
      },

      {
        "<Up>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to next node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<Down>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to previous node",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<Left>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to outer",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<Right>",
        "<Cmd>STSSelectCurrentNode<cr>",
        desc = "Navigate to inner",
        mode = "n",
        noremap = true,
        silent = true,
      },

      -- Swap nodes
      {
        "<Lt>L",
        function()
          vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
          return "g@l"
        end,
        desc = "Swap with previous block",
        mode = "n",
        noremap = true,
        silent = true,
        expr = true,
        nowait = true,
      },

      {
        ">L",
        function()
          vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
          return "g@l"
        end,
        desc = "Swap with next block",
        mode = "n",
        noremap = true,
        silent = true,
        expr = true,
        nowait = true,
      },

      -- Swapping Nodes in Visual Mode
      {
        "<Lt>L",
        "<Cmd>STSSwapPrevVisual<cr>",
        mode = { "x", "v" },
        desc = "Swap with previous block",
        noremap = true,
        silent = true,
        expr = true,
        nowait = true,
      },
      {
        ">L",
        "<Cmd>STSSwapNextVisual<cr>",
        mode = { "x", "v" },
        desc = "Swap with next block",
        noremap = true,
        silent = true,
        expr = true,
        nowait = true,
      },
    },
    config = true,
  },
  {
    "echasnovski/mini.indentscope",
    main = "mini.indentscope",
    opts = function()
      return {
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        },
        -- symbol = "│",
        symbol = "▏",
        options = { try_as_border = true },
      }
    end,
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "nofile", "neotest-summary" },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
  },
  { "arthurxavierx/vim-caser" },
  {
    "Bekaboo/dropbar.nvim",
    keys = {
      { "<leader>j", "<Cmd>lua require('dropbar.api').pick()<CR>" },
    },
    lazy = false,
    opts = {
      bar = {
        enable = function(buf, win)
          if IS_KITTY_SCROLLBACK then return false end
          return not vim.api.nvim_win_get_config(win).zindex
            and vim.bo[buf].buftype == ""
            and vim.api.nvim_buf_get_name(buf) ~= ""
            and not vim.wo[win].diff
            and not IS_KITTY_SCROLLBACK
        end,
      },
      icons = {
        ui = {
          menu = {
            indicator = " ",
          },
          bar = {
            separator = "  ",
          },
        },
      },
      menu = {
        keymaps = {
          ["."] = function()
            local menu = require("dropbar.utils").menu.get_current()
            print(vim.fn.json_encode(menu))
          end,
          ["/"] = function()
            local utils = require "dropbar.utils"
            local menu = utils.menu.get_current()
            if not menu then return end
            menu:fuzzy_find_open()
          end,
          ["i"] = function()
            local utils = require "dropbar.utils"
            local menu = utils.menu.get_current()
            if not menu then return end
            menu:fuzzy_find_open()
          end,
          ["<Esc><Esc>"] = function() vim.cmd "wincmd c" end,
          ["<Esc>"] = function() vim.cmd "wincmd c" end,
          ["q"] = function()
            local api = require "dropbar.api"
            local menu = api.dropbar_menu_t()
            while menu do
              vim.cmd("bd " .. menu.buf)
              menu = api.dropbar_menu_t()
            end
          end,
          ["<Space>"] = function()
            local menu = require("dropbar.api").menu.get_current()
            if not menu then return end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then menu:on_click() end
          end,
        },
      },
    },
    config = true,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  {
    "dmmulroy/tsc.nvim",
    keys = { { "<leader>X", "<cmd>TSC<cr>", desc = "TSC" } },
    opts = {
      use_trouble_qflist = true,
      use_diagnostics = true,
      auto_start_watch_mode = true,
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_extend(
        "force",
        opts,
        ---@type snacks.Config
        {
          statuscolumn = { enabled = false },
          explorer = {
            replace_netrw = true,
          },
          picker = {
            ui_select = true,
            layout = { preset = "ivy", layout = { position = "bottom", height = 0 } },
            sources = {
              files = {
                follow = true,
              },
              explorer = {
                diagnostics_open = true,
                git_status_open = true,
                layout = { preset = "sidebar", layout = { position = "right" }, preview = false },
                win = {
                  input = {
                    keys = {
                      ["-"] = {
                        "explorer_focus_parent",
                        mode = { "n" },
                      },
                      ["<c-s-h>"] = {
                        "resize_wider",
                        mode = { "n", "i" },
                      },
                      ["<c-s-l>"] = {
                        "resize_narrower",
                        mode = { "n", "i" },
                      },
                      ["<c-h>"] = {
                        "focus_editor",
                        mode = { "n", "i" },
                      },
                    },
                  },
                  list = {
                    keys = {
                      ["-"] = {
                        "explorer_focus_parent",
                        mode = { "n" },
                      },
                      ["<c-s-h>"] = {
                        "resize_wider",
                        mode = { "n", "i" },
                      },
                      ["<c-s-l>"] = {
                        "resize_narrower",
                        mode = { "n", "i" },
                      },
                      ["<c-h>"] = {
                        "focus_editor",
                        mode = { "n", "i" },
                      },
                    },
                  },
                },

                actions = {
                  ["explorer_focus_parent"] = function(picker) vim.cmd("cd " .. vim.fn.fnamemodify(picker:dir(), ":h")) end,
                  ["explorer_focus"] = function(picker) vim.cmd("cd " .. picker:dir()) end,
                  ["cancel"] = function() vim.cmd [[wincmd h]] end,
                  ["focus_editor"] = function() vim.cmd [[wincmd h]] end,
                  ["resize_wider"] = function()
                    vim.cmd [[wincmd h]]
                    vim.cmd [[vertical resize -2]]
                    vim.cmd [[wincmd l]]
                  end,
                  ["resize_narrower"] = function()
                    vim.cmd [[wincmd h]]
                    vim.cmd [[vertical resize +2]]
                    vim.cmd [[wincmd l]]
                  end,
                },
              },
            },
            picker = {
              actions = {
                ["explorer_focus_parent"] = function(picker) vim.cmd("cd " .. vim.fn.fnamemodify(picker:dir(), ":h")) end,
                ["explorer_focus"] = function(picker) vim.cmd("cd " .. picker:dir()) end,
                ["cancel"] = function() vim.cmd [[wincmd h]] end,
                ["focus_editor"] = function() vim.cmd [[wincmd h]] end,
                ["resize_wider"] = function()
                  vim.cmd [[wincmd h]]
                  vim.cmd [[vertical resize -2]]
                  vim.cmd [[wincmd l]]
                end,
                ["resize_narrower"] = function()
                  vim.cmd [[wincmd h]]
                  vim.cmd [[vertical resize +2]]
                  vim.cmd [[wincmd l]]
                end,
              },
            },
            formatters = {
              file = {
                filename_first = true,
                truncate = false,
              },
            },
            win = {
              input = {
                keys = {
                  ["<c-a-d>"] = { "inspect", mode = { "n", "i" } },
                  ["<c-a-f>"] = { "toggle_follow", mode = { "i", "n" } },
                  ["<c-a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
                  ["<c-a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
                  ["<c-a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
                  ["<c-a-p>"] = { "toggle_preview", mode = { "i", "n" } },
                  ["<c-a-w>"] = { "cycle_win", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<c-a-d>"] = "inspect",
                  ["<c-a-f>"] = "toggle_follow",
                  ["<c-a-h>"] = "toggle_hidden",
                  ["<c-a-i>"] = "toggle_ignored",
                  ["<c-a-m>"] = "toggle_maximize",
                  ["<c-a-p>"] = "toggle_preview",
                  ["<c-a-w>"] = "cycle_win",
                },
              },
            },
          },
        }
      )
    end,
  },
}
