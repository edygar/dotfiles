local M = {}

M.config = function()
  -- For copilot.vim
  vim.g.copilot_filetypes = {}

  -- vim.cmd [[
  --   imap <silent><script><expr> <C-A> copilot#Accept("\<CR>")
  --   let g:copilot_no_tab_map = v:true
  -- ]]

  local status_ok, copilot = pcall(require, "copilot")
  if not status_ok then
    return
  end

  copilot.setup {
    cmp = {
      enabled = true,
      method = "getCompletionsCycling",
    },
    panel = { -- no config options yet
      enabled = true,
    },
    ft_disable = { "markdown" },
    -- plugin_manager_path = vim.fn.stdpath "data" .. "/site/pack/packer",
    -- server_opts_overrides = {},
  }
end

return M
