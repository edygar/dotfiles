return {
  settings = {
    Lua = {
      type = {
        -- weakUnionCheck = true,
        -- weakNilCheck = true,
        -- castNumberToInteger = true,
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Enable", -- "Enable", "Auto", "Disable"
        await = true,
        paramName = "All", -- "All", "Literal", "Disable"
        paramType = true,
        semicolon = "All", -- "All", "SameLine", "Disable"
        setType = true,
      },
      -- spell = {"the"}
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 2000,
        preloadFileSize = 50000,
      },
      completion = { callSnippet = "Both" },
      telemetry = { enable = false },
    },
  },
}
