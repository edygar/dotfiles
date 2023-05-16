local M = {}
M.config = function()
  local loaded, diffView = pcall(require, "diffview")
  if not loaded then
    return
  end

  local actions = require "diffview.actions"
  diffView.setup {
    keymaps = {
      file_history_panel = {
        ["q"] = function()
          vim.cmd "DiffviewClose"
        end,
        ["<up>"] = actions.select_prev_entry,
        ["K"] = actions.select_prev_entry,
        ["<down>"] = actions.select_next_entry,
        ["J"] = actions.select_next_entry,
      },
    },
  }
end

return M
