-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk

if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
  os.execute("kitty @ load-config --override cursor_trail=0 --no-response 2>/dev/null")
end

local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    -- stylua: ignore
    vim.api.nvim_echo({ { ("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end

vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.fn.setreg("+", vim.fn.getreg('"'))
    end,
  })
  local hoppath = vim.fn.stdpath "data" .. "/lazy/hop.nvim"
  if (vim.uv or vim.loop).fs_stat(hoppath) then
    vim.opt.runtimepath:prepend(hoppath)
    require("hop").setup()
    vim.keymap.set("n", "<leader><leader>", function() require("hop").hint_words() end, { desc = "Hop" })
  end
else
  require "lazy_setup"
  require "polish"
end
