M = {}

M.config = function(opts)
  opts = opts or {}
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    return
  end

  vim.api.nvim_create_user_command("Jest", function()
    vim.cmd [[ :silent :!silent kitty @ goto-layout horizontal; kitty @ launch --type=window --cwd=current zsh -c '. ~/.zshrc; yarn test:watch %' ]]
  end, { nargs = "?" })

  local mappings = {
    L = {
      name = opts.name or "TypeScript",
      r = { "<cmd>Jest<Cr>", "Run tests for current file" },
    },
  }

  which_key.register(mappings, {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  })
end

return M
