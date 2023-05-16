local M = {}
M.config = function()
  local registers = require("registers")
  registers.setup { 
    show_empty = true,
    trim_whitespace = true,
    hide_only_whitespace = 1,
    window = {
        -- The window can't be wider than 100 characters
        max_width = 100,
        -- Don't draw a border around the registers window
        border = "none",
    },
    bind_keys = {
        -- Show the window when pressing " in normal mode, applying the selected register as part of a motion, which is the default behavior of Neovim
        normal = registers.show_window({ mode = "motion" }),
        -- Show the window when pressing " in visual mode, applying the selected register as part of a motion, which is the default behavior of Neovim
        visual = registers.show_window({ mode = "motion" }),
        -- Show the window when pressing <C-R> in insert mode, inserting the selected register, which is the default behavior of Neovim
        insert = registers.show_window({ mode = "insert" }),
      }
  }
end

return M

