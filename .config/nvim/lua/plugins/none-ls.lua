return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")
    local js_ts_filetypes = {
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
    }

    local function is_backoffice_frontend_js_ts(params)
      return js_ts_filetypes[params.ft]
        and params.bufname:match "^/Users/edygar%.oliveira/Code/work/backoffice%-frontend/"
    end

    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      null_ls.builtins.formatting.prettierd.with({
        prefer_local = "node_modules/.bin",
        runtime_condition = function(params) return not is_backoffice_frontend_js_ts(params) end,
      }),
      null_ls.builtins.formatting.stylua,
    })
  end,
}
