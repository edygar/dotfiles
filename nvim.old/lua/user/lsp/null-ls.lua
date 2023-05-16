local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local builtins = null_ls.builtins

null_ls.setup {
  debug = false,
  sources = {
    builtins.formatting.prettier_d_slim.with {
      extra_filetypes = { "toml", "solidity", "prisma" },
    },
    builtins.formatting.eslint_d,
    builtins.formatting.stylua,
    builtins.formatting.shfmt,

    -- diagnostics
    builtins.diagnostics.eslint_d.u,
    builtins.diagnostics.markdownlint,

    -- code actions
    builtins.code_actions.refactoring,
    -- hover
    builtins.code_actions.eslint_d,

    builtins.hover.dictionary,

    require("typescript.extensions.null-ls.code-actions"),
  },
}
