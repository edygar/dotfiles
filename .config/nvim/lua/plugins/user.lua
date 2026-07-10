local IS_KITTY_SCROLLBACK = vim.env.KITTY_SCROLLBACK_NVIM == "true"

local function chars_to_right_of_word()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()
  local word_start = col
  local word_end = col
  while word_start > 0 and line:sub(word_start, word_start):match "[%w_]" do
    word_start = word_start - 1
  end
  if not line:sub(word_start, word_start):match "[%w_]" then word_start = word_start + 1 end
  while word_end <= #line and line:sub(word_end + 1, word_end + 1):match "[%w_]" do
    word_end = word_end + 1
  end
  return col - word_start + 1
end

---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_extend("force", opts, {
        statuscolumn = { enabled = false },
        explorer = { replace_netrw = true },
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
            files = { follow = true },
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
                    border = "rounded",
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                  },
                  { win = "list", border = "none" },
                  {
                    win = "preview",
                    title = "{preview}",
                    height = 0.4,
                    border = "top",
                  },
                },
              },
              win = {
                preview = { zindex = 33 },
                input = {
                  keys = {
                    ["-"] = { "explorer_focus_parent", mode = { "n" } },
                    ["<c-s-h>"] = { "resize_wider", mode = { "n", "i" } },
                    ["<c-s-l>"] = { "resize_narrower", mode = { "n", "i" } },
                    ["<c-h>"] = { "focus_editor", mode = { "n", "i" } },
                  },
                },
                list = {
                  keys = {
                    ["<C-r>"] = { "explorer_reveal", mode = { "n" } },
                    ["R"] = { "explorer_reveal", mode = { "n" } },
                    ["<S-CR>"] = { "explorer_toggle_all", mode = { "n" } },
                    ["-"] = { "explorer_focus_parent", mode = { "n" } },
                    ["<c-s-h>"] = { "resize_wider", mode = { "n", "i" } },
                    ["<c-s-l>"] = { "resize_narrower", mode = { "n", "i" } },
                    ["<c-h>"] = { "focus_editor", mode = { "n", "i" } },
                    ["<c-l>"] = { "navigate_away", mode = { "n", "i" } },
                  },
                },
              },
              actions = {
                explorer_reveal = function(_, item) os.execute("open -R " .. Snacks.picker.util.path(item)) end,
                explorer_toggle_all = function(picker)
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
                explorer_focus_parent = function(picker) vim.cmd("cd " .. vim.fn.fnamemodify(picker:dir(), ":h")) end,
                focus_editor = function() vim.cmd "wincmd h" end,
                navigate_away = function() vim.cmd "KittyNavigateRight" end,
                resize_wider = function()
                  vim.cmd "wincmd h"
                  vim.cmd "vertical resize -2"
                  vim.cmd "wincmd l"
                end,
                resize_narrower = function()
                  vim.cmd "wincmd h"
                  vim.cmd "vertical resize +2"
                  vim.cmd "wincmd l"
                end,
              },
            },
          },
          formatters = {
            file = { filename_first = true, truncate = 1 / 0 },
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
        preview = {},
      })
    end,
  },
  {
    "mbbill/undotree",
    keys = { { "<leader>U", "<Cmd>UndotreeToggle<CR>", mode = "n", desc = "Toggles Undo Tree" } },
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "smoka7/hop.nvim",
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
    dependencies = { "junegunn/fzf.vim" },
    opts = function()
      return { preview = { winblend = 30 } }
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
            win = {
              input = { keys = { ["<c-x>"] = { "delete_worktree", mode = { "n", "i" }, desc = "Delete worktree" } } },
              list = { keys = { ["<c-x>"] = { "delete_worktree", mode = { "n", "i" }, desc = "Delete worktree" } } },
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
    opts = { switch_file_command = "Oil" },
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
      opts.tabline = {
        status.component.fill { hl = { bg = "tabline_bg" } },
        {
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
          status.heirline.make_tablist {
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
          },
          {
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
    branch = "main",
    opts = { indent = { enable = true } },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = true,
    keys = { { "<leader>utc", "<Cmd>TSContext toggle<cr>", mode = "n", desc = "Toggle Treesitter Context" } },
  },
  {
    "yioneko/nvim-vtsls",
    init = function()
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "olrtg/nvim-emmet",
    config = function() vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation) end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround visual selection" },
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
        border = "single",
        padding = { 2, 2, 2, 2 },
        bo = {},
        wo = { winblend = 10 },
      }
      opts.layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      }
      opts.icons.group = ""
      opts.icons.rules = false
      opts.icons.separator = "-"
    end,
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
      { "['", "<Cmd>lua require('dropbar.api').goto_context_start()<CR>", desc = "Go to start of current context" },
      { "]'", "<Cmd>lua require('dropbar.api').select_next_context()<CR>", desc = "Select next context" },
      { "<leader>'", "<Cmd>lua require('dropbar.api').select_next_context()<CR>" },
      { "<leader>,", "<Cmd>lua require('dropbar.api').select_next_context()<CR>" },
      { "<leader>;", "<Cmd>lua require('dropbar.api').select_next_context()<CR>" },
      { "[;", "<Cmd>lua require('dropbar.api').goto_context_start()<CR>", desc = "Go to start of current context" },
      { "];", "<Cmd>lua require('dropbar.api').select_next_context()<CR>", desc = "Select next context" },
    },
    lazy = false,
    opts = function()
      local go_dropbar_next = function()
        local root = require("dropbar.utils").menu.get_current():root()
        root:close()
        local dropbar = require("dropbar.api").get_dropbar(vim.api.nvim_win_get_buf(root.prev_win), root.prev_win)
        if not dropbar then
          dropbar = require("dropbar.utils").bar.get_current()
          if not dropbar then
            root:toggle()
            return
          end
        end
        local current_idx
        for idx, component in ipairs(dropbar.components) do
          if component.menu == root then
            current_idx = idx
            break
          end
        end
        if current_idx == nil or current_idx == #dropbar.components then
          root:toggle()
          return
        end
        vim.defer_fn(function() dropbar:pick(current_idx + 1) end, 100)
      end
      local go_dropbar_prev = function()
        local root = require("dropbar.utils").menu.get_current():root()
        root:close()
        local dropbar = require("dropbar.api").get_dropbar(vim.api.nvim_win_get_buf(root.prev_win), root.prev_win)
        if not dropbar then
          dropbar = require("dropbar.utils").bar.get_current()
          if not dropbar then
            root:toggle()
            return
          end
        end
        local current_idx
        for idx, component in ipairs(dropbar.components) do
          if component.menu == root then
            current_idx = idx
            break
          end
        end
        if current_idx == nil or current_idx == 0 then
          root:toggle()
          return
        end
        vim.defer_fn(function() dropbar:pick(current_idx - 1) end, 100)
      end
      return {
        bar = {
          truncate = false,
          enable = function(buf, win)
            if IS_KITTY_SCROLLBACK then return false end
            return not vim.api.nvim_win_get_config(win).zindex
              and vim.bo[buf].buftype == ""
              and vim.api.nvim_buf_get_name(buf) ~= ""
              and not vim.wo[win].diff
          end,
          sources = function(buf, _)
            local sources = require "dropbar.sources"
            local custom_path = require "custom.dropbar.path"
            local utils = require "dropbar.utils"
            if vim.bo[buf].ft == "markdown" then
              return { custom_path, sources.markdown }
            end
            if vim.bo[buf].buftype == "terminal" then return { sources.terminal } end
            return {
              custom_path,
              utils.source.fallback { sources.lsp, sources.treesitter },
            }
          end,
        },
        icons = {
          ui = {
            menu = { indicator = " " },
            bar = { separator = "  " },
          },
        },
        menu = {
          win_configs = { style = "minimal", border = "rounded" },
          keymaps = {
            ["/"] = function()
              local menu = require("dropbar.utils").menu.get_current()
              if menu then menu:fuzzy_find_open() end
            end,
            ["i"] = function()
              local menu = require("dropbar.utils").menu.get_current()
              if menu then menu:fuzzy_find_open() end
            end,
            ["H"] = go_dropbar_prev,
            ["L"] = go_dropbar_next,
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
            ["<Left>"] = function()
              vim.cmd "wincmd c"
              local menu = require("dropbar.utils").menu.get_current()
              if not menu then go_dropbar_prev() end
            end,
            ["<Right>"] = function()
              local menu = require("dropbar.utils").menu.get_current()
              if not menu then return end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then component:on_click() end
            end,
            ["<Up>"] = "k",
            ["<Down>"] = "j",
          },
        },
      }
    end,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  {
    "dmmulroy/tsc.nvim",
    keys = { { "<leader>X", "<cmd>TSC<cr>", desc = "TSC" } },
    opts = { use_trouble_qflist = true, use_diagnostics = true, auto_start_watch_mode = true },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = { enabled = true, view = "cmdline" },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
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
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    event = "LspAttach",
    opts = {
      backend = "delta",
      backend_opt = {
        delta = {
          args = { "--side-by-side", "--color-only", "--paging=never", "--features=" },
        },
      },
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
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup {
        options = {
          multilines = {
            enabled = true,
            always_show = true,
            trim_whitespaces = false,
            tabstop = 4,
          },
        },
      }
      vim.diagnostic.config { virtual_text = false }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
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
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<Leader>ss", function() require("grug-far").open() end, mode = "n" },
      { "<Leader>sw", function() require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } } end, mode = "n" },
      { "<Leader>sc", function() require("grug-far").open { prefills = { paths = vim.fn.expand "%" } } end, mode = "n" },
    },
  },
  { "knubie/vim-kitty-navigator" },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    opts = {
      {
        callbacks = {
          after_launch = function()
            IS_KITTY_SCROLLBACK = true
          end,
        },
        keymaps_enabled = true,
        paste_window = {
          yank_register_enabled = true,
        },
        scrollback_columns = 1000,
      },
    },
  },
  {
    "okuuva/auto-save.nvim",
    keys = { { "<leader>uts", "<cmd>ASToggle<CR>", mode = "n", desc = "Toggle auto save" } },
    lazy = false,
    opts = {
      enabled = false,
      debounce_delay = 1000,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "InsertLeave" },
        defer_save = { "InsertLeave", "CursorHoldI", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "<leader>E", function() require("oil").open() end, mode = "n", desc = "Open parent directory" },
    },
    opts = {},
  },
  {
    "ziontee113/syntax-tree-surfer",
    lazy = false,
    keys = {
      { "vv", "<Cmd>STSSelectCurrentNode<cr>", desc = "Select current node", mode = "n", noremap = true, silent = true, nowait = true },
      { "<C-M-Left>", "<Cmd>STSSelectPrevSiblingNode<cr>", desc = "Previous sibling node", mode = "x", noremap = true, silent = true },
      { "<C-M-Right>", "<Cmd>STSSelectNextSiblingNode<cr>", desc = "Next sibling node", mode = "x", noremap = true, silent = true },
      { "<C-M-Up>", "<Cmd>STSSelectParentNode<cr>", desc = "Parent node", mode = "x", noremap = true, silent = true },
      { "<C-M-Down>", "<Cmd>STSSelectChildNode<cr>", desc = "Child node", mode = "x", noremap = true, silent = true },
    },
    config = true,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.jump = {
        on_jump = function(_, bufnr)
          vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
        end,
      }
    end,
  },
}
