local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
  return
end

local icons = require "user.icons"

navic.setup {
  icons = vim.tbl_map(function(icon)
    return icon .. " "
  end, vim.tbl_extend("force", {}, icons.kind)),
  highlight = true,
  separator = " " .. icons.ui.ChevronRight .. " ",
  depth_limit = 0,
  depth_limit_indicator = "..",
}
