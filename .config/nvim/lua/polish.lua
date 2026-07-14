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

-- Create an autocommand group

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SnacksPickerExplorer", { clear = true }),
  pattern = "snacks_picker_list",
  callback = function() vim.api.nvim_set_hl(0, "SnacksPickerTree", { bg = "NONE" }) end,
})
