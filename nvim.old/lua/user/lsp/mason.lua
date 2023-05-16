local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
  return
end

mason.setup {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}
mason_lspconfig.setup {
  ensure_installed = {
    "cssls",
    "cssmodules_ls",
    "emmet_ls",
    "html",
    "jdtls",
    "jsonls",
    "solc",
    "tflint",
    "terraformls",
    "tsserver",
    "pyright",
    "yamlls",
    "bashls",
    "clangd",
    "taplo",
    "zk@v0.10.1",
    "lemminx",
  },
  automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

mason_lspconfig.setup_handlers {
  function(server_name) -- default handler (optional)
    local opts = {
      on_attach = require("user.lsp.handlers").on_attach,
      capabilities = require("user.lsp.handlers").capabilities,
    }

    server_name = vim.split(server_name, "@")[1]

    local loaded_custom, custom_config = pcall(require, "user.lsp.settings." .. server_name)
    if loaded_custom then
      opts = vim.tbl_deep_extend("force", opts, custom_config) or opts
    end

    lspconfig[server_name].setup(opts)
  end,
}
