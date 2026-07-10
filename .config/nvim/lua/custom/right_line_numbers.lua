local ns = vim.api.nvim_create_namespace "right_line_numbers"

local function update(buf)
  if not vim.api.nvim_buf_is_loaded(buf) then return end
  if vim.bo[buf].buftype ~= "" then
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    return
  end
  local win = vim.fn.bufwinid(buf)
  if win == -1 then return end
  if not (vim.wo[win].number or vim.wo[win].relativenumber) then
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    return
  end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local count = #lines
  local width = #tostring(count)
  for i = 1, count do
    local num = string.format(" %" .. width .. "d", i)
    vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
      virt_text = { { num, "LineNr" }, { "  ", nil } },
      virt_text_pos = "right_align",
      hl_mode = "combine",
    })
  end
end

local group = vim.api.nvim_create_augroup("right_line_numbers", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function() vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" }) end,
})

vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile", "BufReadPost", "TextChanged", "TextChangedI", "InsertLeave" }, {
  group = group,
  callback = function(args) update(args.buf) end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function(args) vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1) end,
})
