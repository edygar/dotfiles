local M = {}

M.config = function()
  local alpha = require "alpha"
  local icons = require "user.icons"
  local dashboard = require "alpha.themes.dashboard"

  dashboard.section.header.val = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("f", icons.documents.Files .. " Find file", ":UserTelescope find_files <CR>"),
    dashboard.button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", icons.ui.History .. " Recent files", ":UserTelescope oldfiles cwd_only=true<CR>"),
    dashboard.button("t", icons.ui.List .. " Find text", ":UserTelescope live_grep <CR>"),
    dashboard.button("s", icons.ui.SignIn .. " Find Session", ":silent Autosession search <CR>"),
    dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("u", icons.ui.CloudDownload .. " Update", ":PackerSync<CR>"),
    dashboard.button("q", icons.ui.SignOut .. " Quit", ":qa<CR>"),
  }
  local function footer()
    local total_plugins = #vim.tbl_keys(packer_plugins)
    local datetime = os.date "%d-%m-%Y %H:%M:%S"
    local link = "github.com/edygar/nvim"
    local lines = "   "
      .. total_plugins
      .. " plugins"
      .. "   v"
      .. vim.version().major
      .. "."
      .. vim.version().minor
      .. "."
      .. vim.version().patch
      .. "   "
      .. datetime

    lines = lines .. "\n" .. string.rep(" ", math.floor((#lines - #link) / 2)) .. link

    return lines
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true
  -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
  alpha.setup(dashboard.opts)
end

return M
