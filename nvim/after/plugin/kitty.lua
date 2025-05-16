vim.api.nvim_create_autocmd({
  "VimEnter",
  "FocusGained",
  "DirChanged",
  "VimResume",
}, {
  callback = function()
    vim.cmd('silent !kitty @ set-window-title "nvim(' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ')"')
  end,
})

vim.api.nvim_create_autocmd({
  "VimLeave",
  "VimSuspend",
}, {
  callback = function()
    vim.cmd('silent !kitty @ set-window-title ""')
  end,
})
