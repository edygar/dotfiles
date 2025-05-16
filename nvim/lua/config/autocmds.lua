-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "Jaq",
    "qf",
    "notify",
    "help",
    "man",
    "lspinfo",
    "spectre_panel",
    "DressingSelect",
    "tsplayground",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "" },
  callback = function()
    local buf_ft = vim.bo.filetype
    if buf_ft == nil then
      vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "spectre_panel",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> <leader>/ :close<CR>
      nnoremap <silent> <buffer> <esc><esc> :close<CR>
      set nobuflisted
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check if the llama-server is running by grepping its command line.
    local handle = io.popen("pgrep -f 'llama-server'")
    local result = handle:read("*a")
    handle:close()
    if result == "" then
      -- Launch kitty in detached mode running the llama-server command.
      os.execute([[
        kitty-launcher.zsh "Servers" "LLAMA" "llama-server -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF --port 8012 -ngl 99 -fa -ub 1024 -b 1024 --ctx-size 0 --cache-reuse 256"
      ]])
    end
  end,
})
