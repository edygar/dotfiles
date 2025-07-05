-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:
local IS_KITTY_SCROLLBACK = false
local function chars_to_right_of_word()
  -- Get current cursor position
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]

  -- Get the current line
  local line = vim.api.nvim_get_current_line()

  -- Find word boundaries around cursor position
  local word_start = col
  local word_end = col

  -- Find start of word (move backwards)
  while word_start > 0 and line:sub(word_start, word_start):match "[%w_]" do
    word_start = word_start - 1
  end
  if not line:sub(word_start, word_start):match "[%w_]" then word_start = word_start + 1 end

  -- Find end of word (move forwards)
  while word_end <= #line and line:sub(word_end + 1, word_end + 1):match "[%w_]" do
    word_end = word_end + 1
  end

  -- Calculate relative position (1-based)
  local relative_pos = col - word_start + 1

  return relative_pos
end
---@type LazySpec
return {
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
          input = {
            win = {
              relative = "cursor",
              title_pos = "left",
              row = -1,
              col = function() return -chars_to_right_of_word() - 5 end,
            },
          },
          picker = {
            ui_select = true,
            layout = {
              layout = {
                position = "float",

                row = 1,
                width = 0.9,
                height = 0.9,
                border = "none",
                box = "vertical",
                {
                  win = "preview",
                  title = "{preview}",
                  border = "rounded",
                  height = 0.80,
                },
                {
                  box = "vertical",
                  border = "rounded",
                  title = "{title} {live} {flags}",
                  title_pos = "left",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
              },
            },
            sources = {
              files = {
                follow = true,
              },
              lines = {
                layout = {
                  fullscreen = true,
                  layout = {
                    box = "vertical",
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.4,
                    border = "top",
                    title = " {title} {live} {flags}",
                    title_pos = "left",
                    { win = "input", height = 1, border = "bottom" },
                    {
                      box = "horizontal",
                      { win = "list", border = "none" },
                      { win = "preview", title = "{preview}", width = 0.6, border = "left" },
                    },
                  },
                },
              },
              explorer = {
                diagnostics_open = true,
                git_status_open = true,
                layout = {
                  preview = "main",
                  fullscreen = false,
                  layout = {
                    backdrop = false,
                    width = 40,
                    min_width = 40,
                    height = 0,
                    position = "right",
                    border = "none",
                    box = "vertical",
                    {
                      win = "input",
                      height = 1,
                      border = "bottom",
                      title = "{title} {live} {flags}",
                      title_pos = "center",
                    },
                    { win = "list", border = "none" },
                    { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                  },
                },
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
                      ["<S-CR>"] = {
                        "explorer_toggle_all",
                        mode = { "n" },
                      },
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
                  ["explorer_toggle_all"] = function(picker)
                    local Tree = require "snacks.explorer.tree"
                    local start = Tree:find(picker:dir())
                    if start == nil then return end
                    local toggle_to = not start.open

                    local toggle_all
                    toggle_all = function(path)
                      Tree:walk(Tree:find(path), function(node)
                        if node.dir then
                          node.open = toggle_to
                          if toggle_to then
                            Tree:expand(node)
                          else
                            Tree:close(node.path)
                          end
                        end
                      end, { all = true })
                    end

                    toggle_all(picker:dir())
                    require("snacks.explorer.actions").update(picker, { refresh = true })
                  end,
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
                truncate = 1 / 0,
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
    opts = function()
      return {
        preview = {
          winblend = 30,
        },
      }
    end,
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
    opts = function(_, opts)
      local status = require "astroui.status"
      local cached_func = function(func, ...)
        local cached
        local args = { ... }
        return function(self)
          if cached == nil then cached = func(unpack(args)) end
          if type(cached) == "function" then return cached(self) end
          return cached
        end
      end
      opts.winbar = nil
      opts.tabline = { -- bufferline
        status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
        { -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist { -- component for each tab
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
          },
          { -- close button for current tab
            provider = status.provider.close_button { kind = "TabClose", padding = { left = 1, right = 1 } },
            hl = cached_func(status.hl.get_attributes, "tab_close", true),
            on_click = {
              callback = function() require("astrocore.buffer").close_tab() end,
              name = "heirline_tabline_close_tab_callback",
            },
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
    opts = function()
      return {
        bar = {
          truncate = false,
          enable = function(buf, win)
            if IS_KITTY_SCROLLBACK then return false end
            return not vim.api.nvim_win_get_config(win).zindex
              and vim.bo[buf].buftype == ""
              and vim.api.nvim_buf_get_name(buf) ~= ""
              and not vim.wo[win].diff
              and not IS_KITTY_SCROLLBACK
          end,
          sources = function(buf, _)
            local sources = require "dropbar.sources"
            local custom_path = require "custom.dropbar.path"
            local utils = require "dropbar.utils"

            if vim.bo[buf].ft == "markdown" then
              return {
                custom_path,
                sources.markdown,
              }
            end
            if vim.bo[buf].buftype == "terminal" then return {
              sources.terminal,
            } end
            return {
              custom_path,
              utils.source.fallback {
                sources.lsp,
                sources.treesitter,
              },
            }
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
          win_configs = {
            style = "minimal",
            border = "rounded",
            row = function(menu)
              return menu.prev_menu and menu.prev_menu.clicked_at and menu.prev_menu.clicked_at[1] - vim.fn.line "w0"
                or 0
            end,
            ---@param menu dropbar_menu_t
            col = function(menu)
              if menu.prev_menu then
                return menu.prev_menu._win_configs.width + (menu.prev_menu.scrollbar and 1 or 0)
              end
              local mouse = vim.fn.getmousepos()
              local bar = require("dropbar.api").get_dropbar(vim.api.nvim_win_get_buf(menu.prev_win), menu.prev_win)
              if not bar then return mouse.wincol end
              local _, range = bar:get_component_at(math.max(0, mouse.wincol - 1))
              return range and range.start or mouse.wincol
            end,
            relative = "win",
            win = function(menu) return menu.prev_menu and menu.prev_menu.win or vim.fn.getmousepos().winid end,
            height = function(menu)
              return math.max(
                1,
                math.min(#menu.entries, vim.go.pumheight ~= 0 and vim.go.pumheight or math.ceil(vim.go.lines / 4))
              )
            end,
            width = function(menu)
              local min_width = vim.go.pumwidth ~= 0 and vim.go.pumwidth or 8
              if vim.tbl_isempty(menu.entries) then return min_width end
              return math.max(
                min_width,
                math.max(unpack(vim.tbl_map(function(entry) return entry:displaywidth() end, menu.entries)))
              )
            end,
            zindex = function(menu)
              if not menu.prev_menu then return end
              return menu.prev_menu.scrollbar
                  and menu.prev_menu.scrollbar.thumb
                  and vim.api.nvim_win_get_config(menu.prev_menu.scrollbar.thumb).zindex
                or vim.api.nvim_win_get_config(menu.prev_win).zindex
            end,
          },
          keymaps = {
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
            ["<Esc>"] = function() vim.cmd "wincmd c" end,
            ["<Backspace>"] = function() vim.cmd "wincmd c" end,
            ["<C-c>"] = function()
              local menu = require("dropbar.utils").menu.get_current()
              while menu do
                vim.cmd("bd " .. menu.buf)
                menu = require("dropbar.utils").menu.get_current()
              end
            end,
            ["q"] = function()
              local menu = require("dropbar.utils").menu.get_current()
              while menu do
                vim.cmd("bd " .. menu.buf)
                menu = require("dropbar.utils").menu.get_current()
              end
            end,
            ["y"] = function(...)
              local menu = require("dropbar.utils").menu.get_current()
              print(vim.inspect(...))
              print(vim.inspect(menu))
            end,

            ["<Right>"] = function()
              local menu = require("dropbar.utils").menu.get_current()
              if not menu then return end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then component:on_click() end
            end,
            ["<Left>"] = function() vim.cmd "wincmd c" end,
            ["<Up>"] = "k",
            ["<Down>"] = "j",
          },
        },
      }
    end,
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
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true, -- enables the Noice cmdline UI
        view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      },

      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
  {
    "ruifm/gitlinker.nvim",
    keys = {
      { "<leader>gy", nil, mode = "n", desc = "Get repository link to current line" },
      { "<leader>gy", nil, mode = "v", desc = "Get repository link to current line" },
    },
    opts = {},
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "folke/snacks.nvim",
      },
    },
    event = "LspAttach",
    opts = {
      backend = "delta",
      picker = {
        "snacks",
        opts = {
          layout = {
            backdrop = 40,
            position = "float",
            layout = {
              backdrop = 40,
              position = "float",
              row = 1,
              width = 0.9,
              height = 0.9,
              border = "none",
              box = "vertical",
              { win = "preview", title = "{preview}", height = 0.8, width = 0, border = "rounded" },
              {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                title_pos = "left",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
            },
          },
        },
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup {
        options = {
          multilines = {
            -- Enable multiline diagnostic messages
            enabled = true,

            -- Always show messages on all lines for multiline diagnostics
            always_show = true,

            -- Trim whitespaces from the start/end of each line
            trim_whitespaces = false,

            -- Replace tabs with spaces in multiline diagnostics
            tabstop = 4,
          },
        },
      }

      vim.diagnostic.config { virtual_text = false }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", mode = "n", desc = "Open diff view" },
      { "<leader>gD", "<cmd>DiffviewOpen master..HEAD<cr>", mode = "n", desc = "History since master" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", mode = "n", desc = "Open file git history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", mode = "n", desc = "Open Git history" },
      { "<leader>gh", "<cmd>'<,'>DiffviewFileHistory<cr>", mode = "v", desc = "Open file history" },
    },
    opts = function()
      local actions = require "diffview.actions"
      return {
        keymaps = {
          file_history_panel = {
            ["q"] = function() vim.cmd "DiffviewClose" end,
            ["<C-u>"] = actions.scroll_view(-8),
            ["<C-d>"] = actions.scroll_view(8),
            ["<up>"] = actions.select_prev_entry,
            ["K"] = actions.select_prev_entry,
            ["<down>"] = actions.select_next_entry,
            ["J"] = actions.select_next_entry,
          },

          file_panel = {
            ["q"] = function() vim.cmd "DiffviewClose" end,
            ["<C-u>"] = actions.scroll_view(-8),
            ["<C-d>"] = actions.scroll_view(8),
            ["<up>"] = actions.select_prev_entry,
            ["K"] = actions.select_prev_entry,
            ["<down>"] = actions.select_next_entry,
            ["J"] = actions.select_next_entry,
          },
        },
      }
    end,
  },
}
