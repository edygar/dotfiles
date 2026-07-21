local M = {}

local function parse_tree(bufnr, range)
  local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_parser or not parser then return false end
  local ok_parse = pcall(parser.parse, parser, range)
  return ok_parse
end

local function parse_current_tree()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return parse_tree(0, { cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] })
end

local function inclusive_end(bufnr, start_row, end_row, end_col)
  if end_col > 0 then return end_row, end_col - 1 end
  if end_row <= start_row then return end_row, 0 end

  local previous_row = end_row - 1
  local line = vim.api.nvim_buf_get_lines(bufnr, previous_row, previous_row + 1, false)[1] or ""
  return previous_row, math.max(#line - 1, 0)
end

function M.select_current()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  if not parse_current_tree() then
    vim.notify("No syntax tree parser for this buffer", vim.log.levels.WARN, { title = "Syntax tree" })
    return
  end

  local ok, node = pcall(vim.treesitter.get_node, {
    bufnr = bufnr,
    pos = { cursor[1] - 1, cursor[2] },
    ignore_injections = false,
  })
  if not ok or not node then
    vim.notify("No syntax tree node under the cursor", vim.log.levels.WARN, { title = "Syntax tree" })
    return
  end

  local start_row, start_col, end_row, end_col = node:range()
  end_row, end_col = inclusive_end(bufnr, start_row, end_row, end_col)

  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd "normal! v"
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
  -- Keep the cursor at the start of the node, which is where Treewalker
  -- expects to find the anchor for the next movement.
  vim.cmd "normal! o"
end

function M.swap_up_operator()
  parse_current_tree()
  require("treewalker").swap_up()
  M.select_current()
end

function M.swap_down_operator()
  parse_current_tree()
  require("treewalker").swap_down()
  M.select_current()
end

function M.operator(direction)
  vim.go.operatorfunc = "v:lua.require'custom.syntax_tree'.swap_" .. direction .. "_operator"
  return "g@l"
end

function M.swap_visual(direction)
  -- Treewalker leaves the cursor on the moved node. Re-select it to match
  -- syntax-tree-surfer's visual swap behavior.
  vim.cmd "normal! v"
  require("treewalker")["swap_" .. direction]()
  M.select_current()
end

return M
