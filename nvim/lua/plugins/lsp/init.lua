return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall", "LspStart", "LspStop", "LspStatus", "LspRestart" },
    keys = {
      { "<leader>cI", "<CMD>LspInfo<CR>", mode = "n" },
    },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "jose-elias-alvarez/typescript.nvim", init },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazyvim.util").has("nvim-cmp")
        end,
      },
    },
    ---@class PluginLspOpts
    opts = {
      inlay_hints = {
        enabled = true,
      },
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "● ",
        },
        float = {
          show_header = true,
          source = "if_many",
          border = "rounded",
          focusable = true,
          prefix = "● ",
        },
        severity_sort = true,
      },
      -- add any global capabilities here
      capabilities = {},
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        jsonls = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = {
                  vim = true,
                },
              },
            },
          },
        },
        tsserver = {
          settings = {
            inlay_hints = { enabled = true },
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayVariableTypeHints = true,

                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
            experimental = {
              enableProjectDiagnostics = true,
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cF", "<cmd>TypescriptFixAll<CR>",
                { buffer = buffer, desc = "Fix All" })
              vim.keymap.set(
                "n",
                "<leader>cM",
                "<cmd>TypescriptAddMissingImports<CR>",
                { buffer = buffer, desc = "Add missing imports" }
              )
              vim.keymap.set(
                "n",
                "<leader>cO",
                "<cmd>TypescriptOrganizeImports<CR>",
                { buffer = buffer, desc = "Organize Imports" }
              )
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>",
                { desc = "Rename File", buffer = buffer })
              vim.keymap.set("n", "<leader>cU", "<cmd>TypescriptRemoveUnused<CR>", { desc = "Remove unused" })
            end
          end)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      local Util = require("lazyvim.util")
      -- setup autoformat
      require("lazyvim.plugins.lsp.format").setup(opts)
      -- setup formatting and keymaps
      Util.on_attach(function(client, buffer)
        local keysOpts = function(desc, override)
          return vim.tbl_extend("force", { silent = true, buffer = buffer }, { desc = desc }, override or {})
        end

        local map = vim.keymap.set

        map("n", "<leader>c?", vim.diagnostic.open_float, keysOpts("Line Diagnostics"))

        local format = function()
          require("lazyvim.plugins.lsp.format").format({ force = true })
        end

        map("n", "<leader>=", format, keysOpts("Format document"))
        map("v", "<leader>=", "=", keysOpts("Format selected range"))

        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", keysOpts("Go to definition"))
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", keysOpts("Go to declaraction"))
        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", keysOpts("Hover symbol"))
        map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keysOpts("Go to implementation"))
        map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", keysOpts("Go to implementation"))
        map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keysOpts("Go to type definition"))
        map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", keysOpts("Go to references"))
        map("n", "H", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keysOpts("Signature help"))
        map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", keysOpts("Rename symbol"))
        map("v", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", keysOpts("Code actions"))
        map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", keysOpts("Code actions"))
        local function allCodeActions()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end
        map("n", "<leader>cA", allCodeActions, keysOpts("Source Action"))
        map("v", "<leader>cA", allCodeActions, keysOpts("Source Action"))
        map(
          "n",
          "[d",
          '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
          keysOpts("Previous diagnostic message")
        )
        map(
          "n",
          "]d",
          '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
          keysOpts("Next diagnostic message")
        )

        local status_ok, illuminate = pcall(require, "illuminate")
        if status_ok then
          illuminate.on_attach(client)
        end
      end)

      -- diagnostics
      for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      if type(opts.diagnostics.float) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.float.prefix = vim.fn.has("nvim-0.10.0") == 0 and "● "
          or function(diagnostic)
            local icons = require("lazyvim.config").icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "● "
          or function(diagnostic)
            local icons = require("lazyvim.config").icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers

      local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        (status_ok and require("cmp_nvim_lsp").default_capabilities()) or {},
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available thourgh mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed })
        mlsp.setup_handlers({ setup })
      end

      if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp_disable("tsserver", is_deno)
        Util.lsp_disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    ft = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact", "svelte" },
    config = function(_, options)
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
      require("lsp-inlayhints").setup(options)
      local palette = require("onedarker.palette")
      vim.api.nvim_set_hl(0, "LspInlayHint", { fg = palette.gray })

      vim.api.nvim_set_keymap(
        "n",
        "<leader>oi",
        "<cmd>lua require('lsp-inlayhints').toggle()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  -- formatters
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "davidmh/cspell.nvim",
      "williamboman/mason.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function()
      local nls = require("null-ls")
      local builtins = nls.builtins
      local h = require("null-ls.helpers")
      local u = require("null-ls.utils")
      local eslintCwd = h.cache.by_bufnr(function(params)
        return u.root_pattern(
          -- https://eslint.org/docs/latest/user-guide/configuring/configuration-files-new
          "eslint.config.js",
          -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "package.json"
        )(params.bufname)
      end)

      local disabled_filetypes = { "harpoon", "NvimTree_1", "NvimTree", "Bot", "gen.nvim" }
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          require("none-ls.formatting.eslint_d").with({
            cwd = eslintCwd,
          }),
          builtins.formatting.prettierd.with({
            extra_filetypes = { "toml", "solidity", "prisma" },
          }),
          builtins.formatting.stylua,
          builtins.formatting.shfmt,

          -- diagnostics
          require("none-ls.diagnostics.eslint_d").with({
            cwd = eslintCwd,
            disabled_filetypes = disabled_filetypes,
          }),
          builtins.diagnostics.markdownlint.with({
            disabled_filetypes = disabled_filetypes,
          }),
          require("cspell").diagnostics.with({
            disabled_filetypes = disabled_filetypes,
            -- Force the severity to be HINT
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity.HINT
            end,
          }),

          -- code actions
          require("cspell").code_actions,
          require("none-ls.code_actions.eslint_d").with({
            cwd = eslintCwd,
          }),
          builtins.code_actions.refactoring,
          builtins.hover.dictionary,
          builtins.code_actions.gitsigns,
        },
      }
    end,
    config = function(_, opts)
      local null_ls = require("null-ls")

      null_ls.setup(opts)

      local setTimeout = function(callback, timeout)
        local timer = vim.loop.new_timer()
        timer:start(timeout, 0, function()
          timer:stop()
          timer:close()
          callback()
        end)
        return timer
      end

      vim.api.nvim_create_autocmd({
        "OptionSet",
      }, {
        pattern = "spell",
        callback = function()
          if vim.opt.spell:get() then
            setTimeout(function()
              null_ls.enable("cspell")
            end, 50)
          else
            null_ls.disable("cspell")
          end
        end,
      })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        -- "flake8",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  { import = "lazyvim.plugins.extras.lang.json" },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    opts = { virtual_lines = true },
    config = function(_, opts)
      require("lsp_lines").setup(opts)
      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = true,
      })
    end,
    keys = {
      {
        "<leader>cl",
        function()
          local lsp_lines_enabled = not vim.diagnostic.config().virtual_lines
          vim.diagnostic.config({
            virtual_lines = lsp_lines_enabled,
            virtual_text = not lsp_lines_enabled,
          })
        end,
        desc = "Toggle LSP lines",
      },
    },
  },
}
