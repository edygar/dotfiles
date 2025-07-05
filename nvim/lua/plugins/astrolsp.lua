-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- Configuration table of features provided by AstroLSP
      features = {
        codelens = true, -- enable/disable codelens refresh on start
        semantic_tokens = true, -- enable/disable semantic token highlighting
      },
      -- customize lsp formatting options
      formatting = {
        -- control auto formatting on save
        format_on_save = {
          enabled = true, -- enable or disable format on save globally
          allow_filetypes = { -- enable format on save for specified filetypes only
            -- "go",
          },
          ignore_filetypes = { -- disable format on save for specified filetypes
            -- "python",
          },
        },
        disabled = { -- disable formatting capabilities for the listed language servers
          -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
          -- "lua_ls",
        },
        timeout_ms = 1000, -- default format timeout
        -- filter = function(client) -- fully override the default formatting function
        --   return true
        -- end
      },
      -- enable servers that you already have installed without mason
      servers = {
        -- "pyright"
      },
      -- customize language server configuration options passed to `lspconfig`
      ---@diagnostic disable: missing-fields
      config = {
        denols = {
          root_dir = function(filename)
            -- Check if the filename ends with .deno.js or .deno.ts
            if filename:match "%.deno%.js$" or filename:match "%.deno%.ts$" then
              -- Get the parent folder path
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
                importModuleSpecifier = "non-relative",
                importModuleSpecifierEnding = "minimal",
                includePackageJsonAutoImports = "auto",
                updateImportsOnFileMove = {
                  enabled = "always",
                },
                suggest = {
                  completeFunctionCalls = true,
                },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
          root_dir = function(filename)
            -- Check if the filename ends with .deno.js or .deno.ts
            if filename:match "%.deno%.js$" or filename:match "%.deno%.ts$" then return nil end
            return not vim.fs.root(0, { "deno.json", "deno.jsonc" })
                and vim.fs.root(0, {
                  "tsconfig.json",
                  "jsconfig.json",
                  "package.json",
                  ".git",
                })
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
      -- customize how language servers are attached
      handlers = {
        -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
        -- function(server, opts) require("lspconfig")[server].setup(opts) end

        -- the key is the server that is being setup with `lspconfig`
        -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
        -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
      },
      -- Configure buffer local auto commands to add when attaching a language server
      autocmds = {
        -- first key is the `augroup` to add the auto commands to (:h augroup)
        lsp_codelens_refresh = {
          -- Optional condition to create/delete auto command group
          -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
          -- condition will be resolved for each client on each execution and if it ever fails for all clients,
          -- the auto commands will be deleted for that buffer
          cond = "textDocument/codeLens",
          -- cond = function(client, bufnr) return client.name == "lua_ls" end,
          -- list of auto commands to set
          {
            -- events to trigger
            event = { "InsertLeave", "BufEnter" },
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            callback = function(args)
              if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
            end,
            desc = "Refresh codelens (buffer)",
          },
        },
      },
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
              return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
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
          --
          -- ["<Leader>lA"] = {
          --   function() require("tiny-code-action").code_action { context = { only = { "source" }, diagnostics = {} } } end,
          --   desc = "LSP code action",
          --   cond = "textDocument/codeAction",
          -- },
          --
          -- ["<Leader>gA"] = {
          --   function() require("tiny-code-action").code_action { context = { only = { "source" }, diagnostics = {} } } end,
          --   desc = "LSP code action",
          --   cond = "textDocument/codeAction",
          -- },
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

          -- ["<Leader>lA"] = {
          --   function() require("tiny-code-action").code_action { context = { only = { "source" }, diagnostics = {} } } end,
          --   desc = "LSP code action",
          --   cond = "textDocument/codeAction",
          -- },
          --
          -- ["<Leader>gA"] = {
          --   function() require("tiny-code-action").code_action { context = { only = { "source" }, diagnostics = {} } } end,
          --   desc = "LSP code action",
          --   cond = "textDocument/codeAction",
          -- },
        },
      },
      on_attach = function(client, bufnr) client.server_capabilities.semanticTokensProvider = nil end,
    },
  },
}
