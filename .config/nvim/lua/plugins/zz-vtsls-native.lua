---@type LazySpec
return {
  {
    "yioneko/nvim-vtsls",
    init = function()
      -- Neovim 0.12 can register LSP server configs directly through
      -- the native API, so this avoids the old lspconfig.configs bridge.
      vim.lsp.config("vtsls", require("vtsls").lspconfig)
    end,
  },
}
