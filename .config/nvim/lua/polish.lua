local qf_editor = require "custom.quickfix-editor"
require "custom.right_line_numbers"

if vim.fn.has "nvim-0.12" == 1 then
  local ok = pcall(require, "nvim-treesitter.query_predicates")
  if ok then
    local query = require "vim.treesitter.query"
    local aliases = { ex = "elixir", pl = "perl", sh = "bash", ts = "typescript", uxn = "uxntal" }

    local function first_node(match, capture_id)
      local node = match[capture_id]
      if type(node) == "table" then node = node[1] end
      return node
    end

    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then return end

      local alias = vim.treesitter.get_node_text(node, bufnr):lower()
      metadata["injection.language"] = vim.filetype.match { filename = "a." .. alias } or aliases[alias] or alias
    end, { force = true })

    query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then return end

      local value = vim.treesitter.get_node_text(node, bufnr)
      local configured = ({
        ["application/ecmascript"] = "javascript",
        ["importmap"] = "json",
        ["module"] = "javascript",
        ["text/ecmascript"] = "javascript",
      })[value]
      metadata["injection.language"] = configured or vim.split(value, "/", {})[#vim.split(value, "/", {})]
    end, { force = true })
  end
end

vim.keymap.set("n", "<leader>xeq", qf_editor.quickfix_from_paste_prompt)

local function open_indented_blank_line(command)
  local marker = "__nvim_indent_marker__"
  vim.cmd.normal { command .. marker, bang = true }

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local indent = line:match "^%s*"
  if indent == "" then
    local reference_row = command == "O" and row + 1 or row - 1
    indent = string.rep(" ", math.max(vim.fn.indent(reference_row), 0))
  end

  vim.api.nvim_set_current_line(indent or "")
  if indent ~= "" then
    vim.api.nvim_win_set_cursor(0, { row, #indent - 1 })
    vim.cmd.startinsert { bang = true }
  else
    vim.api.nvim_win_set_cursor(0, { row, 0 })
    vim.cmd.startinsert()
  end
end

vim.keymap.set("n", "o", function() open_indented_blank_line "o" end, { desc = "Open line below with indent" })
vim.keymap.set("n", "O", function() open_indented_blank_line "O" end, { desc = "Open line above with indent" })

-- Create an autocommand group

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SnacksPickerExplorer", { clear = true }),
  pattern = "snacks_picker_list",
  callback = function() vim.api.nvim_set_hl(0, "SnacksPickerTree", { bg = "NONE" }) end,
})
