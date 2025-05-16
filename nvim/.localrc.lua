map("n", "<leader>fp", function()
  vim.ui.select(vim.tbl_values(require("lazy").plugins()), {
    prompt = "Go to plugin definition",
    format_item = function(item)
      return item[1]
    end,
  }, function(item)
    if not item then
      return
    end

    vim.cmd("grep " .. item[1])
    vim.fn.execute("normal! zt")
  end)
end)
