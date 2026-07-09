---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      features = {
        codelens = false,
        semantic_tokens = true,
      },
      formatting = {
        format_on_save = {
          enabled = true,
          allow_filetypes = {},
          ignore_filetypes = {},
        },
        disabled = {},
        timeout_ms = 1000,
      },
      servers = {},
      config = {
        denols = {
          root_dir = function(filename)
            if filename:match "%.deno%.js$" or filename:match "%.deno%.ts$" then
              return vim.fn.fnamemodify(filename, ":h")
            end
            return vim.fs.root(0, { "deno.json", "deno.jsonc" })
          end,
          single_file_support = false,
          settings = {},
        },
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              preferences = {
                importModuleSpecifierEnding = "minimal",
                includePackageJsonAutoImports = "auto",
                updateImportsOnFileMove = { enabled = "always" },
                suggest = { completeFunctionCalls = true },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
          root_dir = function(filename)
            if filename:match "%.deno%.js$" or filename:match "%.deno%.ts$" then return nil end
            return not vim.fs.root(0, { "deno.json", "deno.jsonc" })
                and vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
              or nil
          end,
          single_file_support = false,
        },
        lua_ls = {
          workspace = {
            checkThirdParty = false,
            library = {
              "$VIMRUNTIME",
              "$XDG_DATA_HOME/nvim/lazy",
              "${3rd}/luv/library",
            },
          },
        },
      },
      handlers = {},
      autocmds = {},
      mappings = {
        n = {
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
          ["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client)
              return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
            end,
          },
          ["gra"] = {
            function() require("tiny-code-action").code_action() end,
            desc = "LSP code action",
            cond = "textDocument/codeAction",
          },
          ["<Leader>la"] = {
            function() require("tiny-code-action").code_action() end,
            desc = "LSP code action",
            cond = "textDocument/codeAction",
          },
        },
        x = {
          ["gra"] = {
            function() require("tiny-code-action").code_action() end,
            desc = "LSP code action",
            cond = "textDocument/codeAction",
          },
          ["<Leader>la"] = {
            function() require("tiny-code-action").code_action() end,
            desc = "LSP code action",
            cond = "textDocument/codeAction",
          },
        },
      },
    },
  },
}
