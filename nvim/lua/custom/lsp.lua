local lspconfig = require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")
local servers = lsp_installer.get_installed_servers()
local null_ls = require("null-ls")
local prettier = require("prettier")

lsp_installer.setup({
  automatic_installation = true
})

for _, server in pairs(servers) do
  lspconfig[server.name].setup({})
end


null_ls.setup({
  on_attach = function(client)
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("nnoremap <silent><buffer> <Leader>= :lua vim.lsp.buf.format { async = true }<CR>")
      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
    end

    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <Leader>= :lua vim.lsp.buf.format { async = true }<CR><CR>")
    end
  end,
})

prettier.setup({
  bin = 'prettier', -- or `prettierd`
  filetypes = {
    "css",
    "gql",
    "graphql",
    "html",
    "json",
    "less",
    "markdown",
    "scss",
    "yaml",
  },

  -- prettier format options (you can use config files too. ex: `.prettierrc`)
  arrow_parens = "always",
  bracket_spacing = true,
  embedded_language_formatting = "auto",
  end_of_line = "lf",
  html_whitespace_sensitivity = "css",
  jsx_bracket_same_line = false,
  jsx_single_quote = false,
  print_width = 80,
  prose_wrap = "preserve",
  quote_props = "as-needed",
  semi = true,
  single_quote = false,
  tab_width = 2,
  trailing_comma = "es5",
  use_tabs = false,
  vue_indent_script_and_style = false,
})
