require'nvim-treesitter.configs'.setup {
  ensure_installed = {"typescript", "javascript", "python", "lua"},
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
  }
}
