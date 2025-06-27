local qf_editor = require "custom.quickfix-editor"
vim.keymap.set("n", "<leader>xeq", qf_editor.quickfix_from_paste_prompt)
