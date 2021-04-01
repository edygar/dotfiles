local lspconfig = require'lspconfig'
local lspinstall = require'lspinstall'
local capabilities = vim.lsp.protocol.make_client_capabilities()
local customizations = {}

local function setup_servers()
  lspinstall.setup()

  local servers = lspinstall.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup(customizations[server] or {})
  end
end

-- TypeScript setup
customizations.typescript = {
    on_attach = function(client, bufnr)
        -- This makes sure tsserver is not used for formatting (I prefer prettier)
        client.resolved_capabilities.document_formatting = false
    end,

    root_dir = lspconfig.util.root_pattern("package.json", "yarn.lock", "lerna.json", ".git"),
    settings = {documentFormatting = false},
    capabilities = capabilities,
}

-- Deno lsp
customizations.deno = {
  on_attach = function(client, bufnr)
    -- This makes sure tsserver is not used for formatting (I prefer prettier)
    client.resolved_capabilities.document_formatting = false
  end,

  root_dir = lspconfig.util.root_pattern("mod.ts"),
  settings = {documentFormatting = false},
  capabilities = capabilities,
}


-- EFM lsp
customizations.efm = require "custom/lsp/efm"

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


-- Use ehanced LSP stuff
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = true,
        update_in_insert = true,
        virtual_text = true,
    }
)
