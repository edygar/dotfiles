-- Formatting via efm
local prettier = require "custom/lsp/efm/prettier"
local eslint = require "custom/lsp/efm/eslint"
local lspconfig = require'lspconfig'

local languages = {
    typescript = {prettier, eslint},
    javascript = {prettier, eslint},
    ["typescript.jsx"] = {prettier, eslint},
    typescriptreact = {prettier, eslint},
    ["javascript.jsx"] = {prettier, eslint},
    javascriptreact = {prettier, eslint},
    yaml = {prettier},
    json = {prettier},
    html = {prettier},
    scss = {prettier},
    css = {prettier},
    markdown = {prettier}
}

return {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.goto_definition = false
    end,

    root_dir = lspconfig.util.root_pattern("package.json", "yarn.lock", "lerna.json", ".git"),
    filetypes = vim.tbl_keys(languages),
    init_options = {
      documentFormatting = true,
      codeAction = true
    },
    settings = {languages = languages, log_level = 1, log_file = '~/efm.log'},
}

