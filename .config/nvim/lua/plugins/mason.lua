return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
        "prettier",
        "stylua",
        "lua_ls",
        "typescript-language-server",
        "vtsls",
        "pyright",
        "ruff",
        "gopls",
        "clangd",
        "bashls",
        "json-lsp",
        "yaml-language-server",
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      handlers = {
        eslint_d = function() end,
      },
    },
  },
}
