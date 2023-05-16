local icons = require "user.icons"
vim.g.gitblame_enabled = 1

vim.g.gitblame_highlight_group = "Question"
vim.g.gitblame_message_template = " " .. icons.ui.ChevronLeft .. " <summary> • <date> • <author>"
vim.g.gitblame_highlight_group = "LineNr"
