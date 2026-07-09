local qf_editor = require "custom.quickfix-editor"

vim.keymap.set("n", "<leader>xeq", qf_editor.quickfix_from_paste_prompt)

-- Create an autocommand group

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SnacksPickerExplorer", { clear = true }),
  pattern = "snacks_picker_list",
  callback = function() vim.api.nvim_set_hl(0, "SnacksPickerTree", { bg = "NONE" }) end,
})
