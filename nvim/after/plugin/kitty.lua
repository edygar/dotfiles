vim.api.nvim_create_autocmd({
  "VimEnter",
  "DirChanged",
}, {
  callback = function()
    vim.cmd('silent !kitty @ set-window-title "nvim(' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ')"')
  end,
})
