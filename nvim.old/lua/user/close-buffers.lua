local M = {}

M.config = function()
  require("close_buffers").setup()
  vim.api.nvim_create_user_command("Bdeletex", function()
    vim.ui.input({
      prompt = "Delete buffers matching regex:",
    }, function(input)
      if not input == "" then
        require("close_buffers").delete { regex = input }
      end
    end)
  end, { nargs = "?" })
end

return M
