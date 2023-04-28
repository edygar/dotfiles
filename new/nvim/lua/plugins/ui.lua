return {
  -- Preferred theme with transparent BG
  {
    "lunarvim/onedarker.nvim",
    config = function()
      local palette = require("onedarker.palette")
      vim.cmd("colorscheme onedarker")
      vim.cmd("hi TreesitterContextBottom gui=underline guisp=" .. palette.gray)
      vim.api.nvim_set_hl(0, "Whitespace", { fg = palette.gray, bg = palette.bg })
    end,
  },

  -- lsp symbol navigation for lualine
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
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("lazyvim.util").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = "  ",
        highlight = true,
        click = true,
        icons = require("lazyvim.config").icons.kinds,
        lsp = {
          on_attach = true,
          preference = { "tsserver" },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-navic").setup(opts)

      local icon_cache = {}
      local get_icon = function(filename, extension)
        if not filename then
          if vim.bo.modified then
            return " %#WinBarModified# %*"
          end

          if vim.bo.filetype == "terminal" then
            filename = "terminal"
            extension = "terminal"
          else
            filename = vim.fn.expand("%:t")
          end
        end

        local cached = icon_cache[filename]
        if not cached then
          if not extension then
            extension = vim.fn.fnamemodify(filename, ":e")
          end
          local file_icon, hl_group = require("nvim-web-devicons").get_icon(filename, extension)
          cached = " " .. "%#" .. hl_group .. "#" .. file_icon .. " %*"
          icon_cache[filename] = cached
        end
        return cached
      end

      function Status_get_filename()
        local has_icon, icon = pcall(get_icon)
        if has_icon then
          return icon
        else
          return " %t"
        end
      end

      vim.o.winbar = [[ %{%v:lua.Status_get_filename()%}  %{%v:lua.require("nvim-navic").get_location()%} ]]
    end,
  },

  -- Indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- Active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    active = false,
    main = "mini.indentscope",
    opts = function()
      return {
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        },
        symbol = "│",
        options = { try_as_border = true },
      }
    end,
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 0,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      { "<a-n>", "<cmd>lua require('illuminate').next_reference({ wrap = true })<CR>", desc = "Next Reference" },
      {
        "<a-p>",
        "<cmd>lua require('illuminate').next_reference({ reverse = true, wrap = true })<CR>",
        desc = "Prev Reference",
      },
    },
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

          local clients = vim.lsp.get_active_clients()
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

          if client_names_str_len == 0 and not copilot_active then
            return ""
          else
            return language_servers
          end
        end,
        padding = 1,
        cond = function()
          return vim.o.columns > 80
        end,
      }

      local mode_color = {
        n = "#519fdf",
        i = "#c18a56",
        v = "#b668cd",
        [""] = "#b668cd",
        V = "#b668cd",
        -- c = '#B5CEA8',
        -- c = '#D7BA7D',
        c = "#46a6b2",
        no = "#D16D9E",
        s = "#88b369",
        S = "#c18a56",
        [""] = "#c18a56",
        ic = "#d05c65",
        R = "#D16D9E",
        Rv = "#d05c65",
        cv = "#519fdf",
        ce = "#519fdf",
        r = "#d05c65",
        rm = "#46a6b2",
        ["r?"] = "#46a6b2",
        ["!"] = "#46a6b2",
        t = "#d05c65",
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { "alpha", "dashboard" },
        },
        sections = {
          lualine_a = { "mode", "branch", "tabs" },
          lualine_b = {
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
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {},
          lualine_y = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
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
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
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
            language_server,
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
}
