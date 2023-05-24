return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/typescript.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazyvim.util").has("nvim-cmp")
        end,
      },
    },
    ---@class PluginLspOpts
    opts = {
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
      require("lazyvim.plugins.lsp.format").autoformat = opts.autoformat
      -- setup formatting and keymaps
      Util.on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.format").on_attach(client, buffer)
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
        map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", keysOpts("Code actions"))
        map("n", "<leader>cA", function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end, keysOpts("Source Action"))
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

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      local builtins = nls.builtins
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          builtins.formatting.prettier_d_slim.with({
            extra_filetypes = { "toml", "solidity", "prisma" },
          }),
          builtins.formatting.eslint_d,
          builtins.formatting.stylua,
          builtins.formatting.shfmt,

          -- diagnostics
          builtins.diagnostics.eslint_d.u,
          builtins.diagnostics.markdownlint,

          -- code actions
          require("typescript.extensions.null-ls.code-actions"),
          builtins.code_actions.gitsigns,
          builtins.code_actions.eslint_d,
          builtins.hover.dictionary,
        },
      }
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
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    keys = {
      { "<leader>cl", "<cmd>lua require('lsp_lines').toggle()<cr>", desc = "Toggle LSP lines" },
    },
  },
}
