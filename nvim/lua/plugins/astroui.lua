-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    status = {
      tabline = {
        enabled = true,
        show_numbers = true, -- This enables tab numbers
      },
    },
    -- change colorscheme
    colorscheme = "onedarker",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      onedarker = {
        Normal = { bg = "NONE" },
        NonText = { fg = "#808080" },
        NormalFloat = { fg = "NONE", bg = "NONE" },
        Folded = { fg = "#808080", bg = "#1E1E1E" },

        FoldColumn = { bg = "NONE" },
        CursorLine = { bg = "#1E1E1E" },
        SignColumn = { bg = "NONE" },
        LineNr = { bg = "#1E1E1E" },
        CursorLineNr = { bg = "#262626" },
        Cursor = { bg = "#1E1E1E" },
        ColorColumn = { bg = "#1E1E1E" },

        IlluminatedWordText = { bg = "#262626" },
        IlluminatedWordRead = { link = "IlluminatedWordText" },
        IlluminatedWordWrite = { link = "IlluminatedWordText" },

        SnacksPickerTree = { bg = "NONE" },
        Title = {
          bold = false,
          bg = "NONE",
          fg = "#519FDF",
        },
        SnacksIndentScope = {
          link = "Normal",
        },
        SnacksPickerPrompt = {
          bg = "NONE",
        },

        TreesitterContext = { bg = "NONE" },
        TreesitterContextBottom = { underline = true, sp = "#808080" },
        Whitespace = { fg = "#808080", bg = "NONE" },

        WinBar = { bg = "NONE" },
        WinBarNC = {
          bg = "NONE",
          fg = "NONE",
        },

        SnacksPicker = { link = "NormalFloat" },
        SnacksPickerBorder = { link = "FloatBorder" },
        ["DiagnosticVirtualTextError"] = {
          bg = "#301111",
          fg = "#DB4B4B",
        },
        ["DiagnosticVirtualTextWarn"] = {
          bg = "#342713",
          fg = "#EEAF58",
        },
        DiffviewDiffAddAsDelete = { bg = "#4B1818" },
        DiffDelete = { fg = "#4B1818", bg = "#4B1818" },
        DiffviewDiffDelete = { bg = "#4B1818" },
        DiffAdd = { bg = "#163003" },
        DiffChange = { bg = "#0B1802" },
        DiffText = { bg = "#163003" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
  dependencies = {
    {
      "lunarvim/onedarker.nvim",
      priority = 1000,
      config = function()
        local palette = require "onedarker.palette"
        palette.bg = "NONE"
        palette.alt_bg = "#1E1E1E"
      end,
    },
  },
}
