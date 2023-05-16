M = {}
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

vim.api.nvim_set_hl(0, "LuaLineSeparator", { bg = "#282C34", fg = "#1e222a" })
vim.api.nvim_set_hl(0, "PreTabs", { bg = "#24282E", fg = "#1e222a" })

local function contains(t, value)
  for _, v in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

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

local mode = {
  -- mode component
  function()
    -- return "▊"
    return "  %#ModeSeparator#%*"
    -- return "  "
  end,
  color = function()
    vim.api.nvim_set_hl(0, "ModeSeparator", { fg = "#1e222a", bg = mode_color[vim.fn.mode()] })
    -- auto change color according to neovims mode
    return { bg = mode_color[vim.fn.mode()] }
  end,
  padding = 0,
}

local hide_in_width_60 = function()
  return vim.o.columns > 60
end

local hide_in_width = function()
  return vim.o.columns > 80
end

local hide_in_width_100 = function()
  return vim.o.columns > 100
end

local icons = require "user.icons"

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
  colored = true,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = icons.git.Add .. " ", modified = icons.git.Mod .. " ", removed = icons.git.Remove .. " " }, -- changes diff symbols
  cond = hide_in_width_60,
  -- separator = "%#SLSeparator#" .. "│ " .. "%*",
}

local filetype = {
  "filetype",
  fmt = function(str)
    local ui_filetypes = {
      "help",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "",
    }

    if str == "toggleterm" then
      -- 
      return "%#SLTermIcon#" .. " " .. "%*"
    end

    if contains(ui_filetypes, str) then
      return ""
    else
      return str
    end
  end,
  icons_enabled = true,
}

local branch = {
  "branch",
  icon = "%#SLGitIcon#" .. "" .. "%*" .. "%#SLBranchName#",
  colored = true,
  separator = "%#PreTabs#%*",
}

local current_signature = {
  function()
    local buf_ft = vim.bo.filetype

    if buf_ft == "toggleterm" then
      return ""
    end
    if not pcall(require, "lsp_signature") then
      return ""
    end
    local sig = require("lsp_signature").status_line(30)
    local hint = sig.hint

    if not require("user.functions").isempty(hint) then
      -- return "%#SLSeparator#│ : " .. hint .. "%*"
      return "%#SLSeparator# " .. hint .. "%*"
    end

    return ""
  end,
  cond = hide_in_width_100,
  padding = 0,
}

local spaces = {
  function()
    local buf_ft = vim.bo.filetype

    local ui_filetypes = {
      "help",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "Outline",
      "spectre_panel",
      "DressingSelect",
      "",
    }
    local space = ""

    if contains(ui_filetypes, buf_ft) then
      space = " "
    end

    -- TODO: update codicons and use their indent
    return "  " .. vim.api.nvim_buf_get_option(0, "shiftwidth") .. space
  end,
  padding = 0,
  -- separator = "%#SLSeparator#" .. " │" .. "%*",
  cond = hide_in_width_100,
}

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

    if contains(ui_filetypes, buf_ft) then
      return M.language_servers
    end

    local clients = vim.lsp.buf_get_clients()
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
    local s = require "null-ls.sources"
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
    local client_names_str = table.concat(client_names, ", ")

    -- check client_names_str if empty
    local language_servers = ""
    local client_names_str_len = #client_names_str
    if client_names_str_len ~= 0 then
      language_servers = client_names_str
    end

    if client_names_str_len == 0 and not copilot_active then
      return ""
    else
      M.language_servers = language_servers
      return language_servers
    end
  end,
  padding = 1,
  cond = hide_in_width,
  -- separator = "%#SLSeparator#" .. " │" .. "%*",
}

local location = {
  "location",
  color = function()
    -- darkerplus
    -- return { fg = "#252525", bg = mode_color[vim.fn.mode()] }
    return { fg = "#1E232A", bg = mode_color[vim.fn.mode()] }
  end,
}

local tabs = {
  "tabs",
  max_length = vim.o.columns / 3, -- Maximum width of tabs component.
  mode = 0, -- 0: Shows tab_nr

  tabs_color = {
    -- Same values as the general color option can be used here.
    active = { fg = "#FFF", bg = "#24282E" }, -- Color for active tab.
    inactive = { fg = "#515964", bg = "#24282E" }, -- Color for inactive tab.
  },
}

lualine.setup {
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "auto",
    disabled_filetypes = { "alpha", "dashboard" },
    always_divide_middle = true,
    component_separators = { left = "%#LuaLineSeparator# %*", right = "%#LuaLineSeparator#%*" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { mode, branch, tabs },
    lualine_b = { diagnostics },
    lualine_c = { current_signature },
    lualine_x = { diff, "lsp_progress", language_server, filetype },
    lualine_y = {},
    lualine_z = { location, "progress" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = { "location" },
    lualine_y = { "progress" },
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
