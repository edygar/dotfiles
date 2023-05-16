local colorscheme = "onedarker"
local palette = require "onedarker.palette"
palette.bg = nil
palette.alt_bg = nil

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
