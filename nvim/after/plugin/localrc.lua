function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_autocmd({
  "VimEnter",
  "DirChanged",
}, {
  callback = function()
    local file = vim.fn.expand(vim.fn.getcwd() .. "/.localrc.lua")
    map("n", "<leader>z", "<cmd>edit " .. file .. "<CR>", { noremap = true, desc = "Edit localrc file" })

    vim.api.nvim_create_autocmd({
      "BufWritePost",
    }, {
      pattern = file,
      callback = function()
        dofile(file)
      end,
    })

    vim.cmd('silent !kitty @ set-window-title "nvim(' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ')"')
    if vim.fn.filereadable(file) == 1 then
      dofile(file)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/.localrc.lua",
  callback = function()
    vim.defer_fn(function()
      vim.cmd("LspStop")
    end, 1000)
  end,
})
