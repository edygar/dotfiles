-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
local function map(mode, maps, fn, opts)
  for _, key in ipairs(maps) do
    vim.keymap.set(mode, key, fn, opts)
  end
end

local lspconfig = require "lspconfig"
local util = require "lspconfig.util"

---@type LazySpec
return {
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
      vtsls = {
        on_attach = function(_, bufnr)
          map(
            "n",
            { "grA", "<leader>lrA" },
            [[ <Cmd>lua vim.lsp.buf.code_action({ context = { only = { "source", "refactor", "quickfix" } } })<CR> ]],
            { buffer = bufnr, desc = "Go to source definition" }
          )
          map(
            "n",
            { "gD" },
            "<cmd>VtsExec goto_source_definition<CR>",
            { buffer = bufnr, desc = "Go to source definition" }
          )
          map(
            "n",
            { "grm", "<leader>lm" },
            "<cmd>VtsExec add_missing_imports<CR>",
            { buffer = bufnr, desc = "Add missing imports" }
          )
          map(
            "n",
            { "gro", "<leader>lo" },
            "<cmd>VtsExec organize_imports<CR>",
            { buffer = bufnr, desc = "Organize Imports" }
          )
          map(
            "n",
            { "grN", "<leader>lN", "<leader>lR" },
            "<cmd>VtsExec rename_file<CR>",
            { desc = "Rename File", buffer = bufnr }
          )
          map("n", { "gru", "<leader>lu" }, "<cmd>VtsExec remove_unused<CR>", { desc = "Remove unused" })

          vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
            local locations = command.arguments[3]
            local clt = vim.lsp.get_client_by_id(ctx.client_id)
            if clt == nil then return end

            if locations and #locations > 0 then
              local items = vim.lsp.util.locations_to_items(locations, clt.offset_encoding)
              vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
              vim.api.nvim_command "lopen"
            end
          end
        end,
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
          },
        },
        denols = {
          root_dir = util.root_pattern("deno.json", "deno.jsonc"),
        },

        vtsls = {
          root_dir = function()
            return not vim.fs.root(0, { "deno.json", "deno.jsonc" })
              and vim.fs.root(0, {
                "tsconfig.json",
                "jsconfig.json",
                "package.json",
                ".git",
              })
          end,
          single_file_support = false,
        },
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
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
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

        ["<Leader>grF"] = {
          function()
            vim.cmd "silent! VtsExec remove_unused"
            vim.cmd "silent! VtsExec remove_unused_imports"
            vim.cmd "silent! VtsExec organize_imports "
            vim.cmd "silent! EslintFixAll"
          end,
          desc = "Fix all issues from Eslint",
          cond = function(client) return client.name == "eslint" or client.name == "vtsls" end,
        },

        ["<Leader>lF"] = {
          function()
            vim.cmd "silent! VtsExec add_missing_imports"
            vim.cmd "silent! VtsExec remove_unused"
            vim.cmd "silent! VtsExec remove_unused_imports"
            vim.cmd "silent! VtsExec organize_imports "
            vim.cmd "silent! EslintFixAll"
          end,
          desc = "Fix all issues from Eslint",
          cond = function(client) return client.name == "eslint" or client.name == "vtsls" end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
      local eslintClient = vim.lsp.get_clients { name = "eslint", bufnr = bufnr }
      if client.name == "eslint" then eslintClient = client end

      if eslintClient then
        local vtslsClient = vim.lsp.get_clients({ name = "vtsls", bufnr = bufnr })[1]
        if vtslsClient then
          vtslsClient.server_capabilities.documentFormattingProvider = false
          vtslsClient.server_capabilities.documentRangeFormattingProvider = false
        end
      end
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- set up autocommand to choose the correct language server
        eslint_over_typescript_formatting = {
          {
            event = "LspAttach",
            callback = function(args)
              local bufnr = args.buf
              local client = vim.lsp.get_client_by_id(args.data.client_id)

              if client == nil then return end

              local eslintClient = vim.lsp.get_clients { name = "eslint", bufnr = bufnr }
              if client.name == "eslint" then eslintClient = client end

              if eslintClient then
                local vtslsClient = vim.lsp.get_clients({ name = "vtsls", bufnr = bufnr })[1]
                if vtslsClient then
                  vtslsClient.server_capabilities.documentFormattingProvider = false
                  vtslsClient.server_capabilities.documentRangeFormattingProvider = false
                end
              end
            end,
          },
        },
      },
    },
  },
}
