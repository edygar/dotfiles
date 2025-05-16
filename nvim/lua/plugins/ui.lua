return {
  -- Preferred theme with transparent BG
  {
    "lunarvim/onedarker.nvim",
    config = function()
      local palette = require("onedarker.palette")
      local hl = vim.api.nvim_set_hl

      palette.bg = "NONE"
      palette.alt_bg = "NONE"
      palette.hint = palette.green

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          if vim.g.colors_name ~= "onedarker" then
            return
          end

          hl(0, "TreesitterContextBottom", { underline = true, sp = palette.gray })
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
        end,
      })
      vim.cmd("colorscheme onedarker")
    end,
  },

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>on",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      render = "minimal",
      background_colour = "#272727",
      timeout = 3000,
      stages = "fade",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("lazyvim.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end

      pcall(function()
        require("telescope").load_extension("notify")
        require("telescope").load_extension("noice")
      end)
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = true,
        relative = "cursor",
        insert_only = false,
        mappings = {
          n = {
            ["<Esc><Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<C-P>"] = "HistoryPrev",
            ["<Up>"] = "HistoryPrev",
            ["<C-N>"] = "HistoryNext",
            ["<Down>"] = "HistoryNext",
          },
        },
      },
      select = {
        enabled = true,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      cmdline = {
        enabled = true, -- enables the Noice cmdline UI
        view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      },
      views = {

        cmdline_popupmenu = {
          relative = "cursor",
          position = "auto",
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { "MunifTanjim/nui.nvim", lazy = false },
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },

  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(
        ---@class wk.Opts
        {
          win = {
            no_overlap = true,
            border = "single", -- none, single, double, shadow
            -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
            padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
            bo = {},
            wo = {
              winblend = 10,
            },
          },
          layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
          },
        }
      )
      wk.add({
        { "<leader>b", group = "Buffers" },
        { "<leader>s", group = "Sessions" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "Marks" },
        { "<leader>o", group = "Toggle options" },
        { "<leader>r", hidden = true },
        { "<leader>=", hidden = true },
      })
    end,
  },

  {
    "junegunn/fzf.vim",
    dependencies = {
      "junegunn/fzf",
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

  -- lsp symbol navigation for lualine and winbar
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").set_icon({
        sh = {
          icon = "",
          color = "#1DC123",
          cterm_color = "59",
          name = "Sh",
        },
        [".gitattributes"] = {
          icon = "",
          color = "#e24329",
          cterm_color = "59",
          name = "GitAttributes",
        },
        [".gitconfig"] = {
          icon = "",
          color = "#e24329",
          cterm_color = "59",
          name = "GitConfig",
        },
        [".gitignore"] = {
          icon = "",
          color = "#e24329",
          cterm_color = "59",
          name = "GitIgnore",
        },
        [".gitlab-ci.yml"] = {
          icon = "",
          color = "#e24329",
          cterm_color = "166",
          name = "GitlabCI",
        },
        [".gitmodules"] = {
          icon = "",
          color = "#e24329",
          cterm_color = "59",
          name = "GitModules",
        },
        ["diff"] = {
          icon = "",
          color = "#e24329",
          cterm_color = "59",
          name = "Diff",
        },
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    branch = "feat-fuzzy-finding",
    keys = {
      { "<leader>j", "<cmd>lua require('dropbar.api').pick()<CR>" },
    },
    lazy = false,
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")

          if vim.bo[buf].ft == "markdown" then
            return {
              require("custom.dropbar.path"),
              utils.source.fallback({
                sources.treesitter,
                sources.markdown,
                sources.lsp,
              }),
            }
          end
          return {

            require("custom.dropbar.path"),
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },
      menu = {
        keymaps = {
          ["/"] = function()
            local api = require("dropbar.api")
            local menu = api.get_current_dropbar_menu()
            api.fuzzy_find_toggle({ menu = menu })
          end,
          ["<Esc><Esc>"] = function()
            vim.cmd("wincmd c")
          end,
          ["<Esc>"] = function()
            vim.cmd("wincmd c")
          end,
          ["q"] = function()
            local api = require("dropbar.api")
            local menu = api.get_current_dropbar_menu()
            while menu do
              vim.cmd("bd " .. menu.buf)
              menu = api.get_current_dropbar_menu()
            end
          end,
          ["<Space>"] = function()
            local menu = require("dropbar.api").get_current_dropbar_menu()
            if not menu then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then
              menu:on_click()
            end
          end,
        },
      },
    },
    config = true,
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },

  -- Indent guides for Neovim
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

  -- Active indent guide and indent text objects
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
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- references
  {
    "yamatsum/nvim-cursorline",
    opts = function()
      local palette = require("onedarker.palette")
      return {
        cursorline = {
          enable = false,
          timeout = 100,
          number = true,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = {
            underline = false,
            bg = palette.reference,
          },
        },
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("lazyvim.config").icons
      local Util = require("lazyvim.util")

      local language_servers = ""
      local language_server = {
        function()
          local buf_ft = vim.bo.filetype
          local ui_filetypes = {
            "help",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "lir",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "DressingSelect",
            "bash",
            "harpoon",
            "",
          }

          local function contains(t, value)
            for _, v in pairs(t) do
              if v == value then
                return true
              end
            end
            return false
          end

          if contains(ui_filetypes, buf_ft) then
            return language_servers
          end

          local clients = vim.lsp.get_clients()
          local client_names = {}
          local copilot_active = false

          -- add client
          for _, client in pairs(clients) do
            if client.name ~= "copilot" and client.name ~= "null-ls" then
              table.insert(client_names, client.name)
            end
            if client.name == "copilot" then
              copilot_active = true
            end
          end

          -- add formatter
          local s = require("null-ls.sources")
          local available_sources = s.get_available(buf_ft)
          local registered = {}
          for _, source in ipairs(available_sources) do
            for method in pairs(source.methods) do
              registered[method] = registered[method] or {}
              table.insert(registered[method], source.name)
            end
          end

          local formatter = registered["NULL_LS_FORMATTING"]
          local linter = registered["NULL_LS_DIAGNOSTICS"]
          if formatter ~= nil then
            vim.list_extend(client_names, formatter)
          end
          if linter ~= nil then
            vim.list_extend(client_names, linter)
          end

          if copilot_active then
            table.insert(client_names, icons.git.Octoface .. " ")
          end

          -- join client names with commas
          local client_names_str = table.concat(client_names, " │ ")

          -- check client_names_str if empty
          local client_names_str_len = #client_names_str
          if client_names_str_len ~= 0 then
            language_servers = client_names_str
          end

          -- if client_names_str_len == 0 and not copilot_active then
          --   return ""
          -- else
          --   return language_servers
          -- end
          return language_servers
        end,
        padding = 1,
        cond = function()
          return vim.o.columns > 80
        end,
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { "alpha", "dashboard" },
          section_separators = {
            left = "",
            right = "",
          },
          component_separators = {
            left = "╱",
            right = "╱",
          },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = {
            "mode",
            "branch",
          },
          lualine_b = {
            { "tabs", separator = "╱" },
            "diagnostics",
            {
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
            language_server,
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "#ff9e64" },
            },
          },
          lualine_x = {
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_y = {

            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = Util.fg("Statement"),
            },

            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },

            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            "lsp_progress",
            "progress",
            "location",
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre" },
    opts = {
      filetype = { "*" },
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = false, -- "Name" codes like Blue oe blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes: foreground, background, virtualtext
      mode = "background", -- Set the display mode.)
    },
  },
  {
    "goolord/alpha-nvim",
    opts = function()
      require("alpha")
      require("alpha.term")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        -- dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"

      dashboard.section.header.val = {
        "⠀⠀⠀⠀⠀⠀⠀⢀⣴⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣦⡀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣦⡀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣦⡀⠀⠀⠀",
        "⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣦⡀⠀",
        "⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣦",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⠻⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟",
        "⠀⠈⠻⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀",
        "⠀⠀⠀⠈⠻⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠈⠻⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠈⠻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⠟⠁⠀⠀⠀⠀⠀⠀⠀",
      }

      return dashboard.config
    end,
  },
}
