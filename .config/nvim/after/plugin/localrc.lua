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

local function find_package_root(file_path)
  local package_json = vim.fs.find("package.json", {
    path = vim.fs.dirname(file_path),
    upward = true,
    type = "file",
  })[1]

  return package_json and vim.fs.dirname(package_json) or nil
end

local function eslint_fix_backoffice_file(args)
  local bufnr = args.buf
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path == "" or vim.bo[bufnr].modified then return end
  if not file_path:match "^/Users/edygar%.oliveira/Code/work/backoffice%-frontend/" then return end
  if not vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact" }, vim.bo[bufnr].filetype) then return end

  local package_root = find_package_root(file_path)
  if not package_root then return end

  local eslint = package_root .. "/node_modules/.bin/eslint"
  local cmd = vim.fn.executable(eslint) == 1 and eslint or "npm"
  local cmd_args = vim.fn.executable(eslint) == 1 and { "--fix", file_path } or { "exec", "--", "eslint", "--fix", file_path }

  vim.system(vim.list_extend({ cmd }, cmd_args), { cwd = package_root, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local output = vim.trim((result.stderr or "") .. "\n" .. (result.stdout or ""))
        if output ~= "" then vim.notify(output, vim.log.levels.WARN, { title = "eslint --fix failed" }) end
        return
      end

      if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].modified then return end
      if vim.api.nvim_buf_get_name(bufnr) ~= file_path then return end

      vim.cmd "checktime"
    end)
  end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("BackofficeFrontendEslintFixAfterSave", { clear = true }),
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = eslint_fix_backoffice_file,
})

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

    if vim.env.KITTY_SCROLLBACK_NVIM == "true" then return end

    if vim.fn.filereadable(file) == 1 then dofile(file) end
  end,
})
