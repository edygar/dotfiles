function map(mode, lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Function to get current git branch
local function get_git_branch()
  local handle = io.popen "git branch --show-current 2>/dev/null"
  if handle then
    local branch = handle:read("*a"):gsub("\n", "")
    handle:close()
    return branch ~= "" and branch or nil
  end
  return nil
end

vim.api.nvim_create_autocmd({
  "VimEnter",
  "DirChanged",
  "VimResume",
}, {
  callback = function()
    local file = vim.fn.expand(vim.fn.getcwd() .. "/.localrc.lua")
    map("n", "<leader>z", "<cmd>edit " .. file .. "<CR>", { noremap = true, desc = "Edit localrc file" })

    vim.api.nvim_create_autocmd({
      "BufWritePost",
    }, {
      pattern = file,
      callback = function() dofile(file) end,
    })

    -- Enhanced title with git branch
    local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local branch = get_git_branch()
    local title = string.format("nvim(%s)", dir_name)

    if branch then title = string.format("[%s] %s", branch, title) end

    vim.cmd('silent !kitty @ set-window-title "' .. title .. '"')

    if vim.fn.filereadable(file) == 1 then dofile(file) end
  end,
})
