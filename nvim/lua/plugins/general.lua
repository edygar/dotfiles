return {
  {
    "folke/persistence.nvim",
    main = "persistence",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
      options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
    },
    keys = {
      {
        "<leader>ps",
        '[[<cmd>lua require("persistence").load()<cr>]]',
        desc = "restore the session for the current directory",
      },
      {
        "<leader>pl",
        '[[<cmd>lua require("persistence").load({ last = true })<cr>]]',
        desc = "restore the last session",
      },
      {
        "<leader>pd",
        '[[<cmd>lua require("persistence").stop()<cr>]]',
        desc = "stop Persistence => session won't be saved on exit",
      },
    },
  },
}
