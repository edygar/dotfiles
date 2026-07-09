return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      null_ls.builtins.formatting.prettierd.with({
        prefer_local = ".node_modules/.bin",
      }),
      null_ls.builtins.diagnostics.eslint_d.with({
        prefer_local = ".node_modules/.bin",
      }),
      null_ls.builtins.formatting.stylua,
    })
  end,
}
