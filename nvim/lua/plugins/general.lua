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
        "<leader>sl",
        '[[<cmd>lua require("persistence").load()<cr>]]',
        desc = "restore the session for the current directory",
      },
      {
        "<leader>sr",
        '[[<cmd>lua require("persistence").load({ last = true })<cr>]]',
        desc = "restore the last session",
      },
      {
        "<leader>sd",
        '[[<cmd>lua require("persistence").stop()<cr>]]',
        desc = "stop Persistence => session won't be saved on exit",
      },
    },
  },
  {
    "imNel/monorepo.nvim",
    lazy = false,
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope").extensions.monorepo.monorepo()
        end,
        mode = "n",
        desc = "Find Project in Monorepo organization",
      },

      {
        "<leader>pa",
        "<cmd>lua require('monorepo').add_project()<CR>",
        mode = "n",
        desc = "Add Project in Monorepo organization",
      },

      {
        "<leader>pd",
        "<cmd>lua require('monorepo').remove_project()<CR>",
        mode = "n",
        desc = "Remove Project in Monorepo organization",
      },
      {

        "<leader>pp",
        "<cmd>lua require('monorepo').toggle_project()<cr>",
        mode = "n",
        desc = "Toogle Projects in Monorepo organization",
      },
    },

    config = function()
      require("monorepo").setup({
        silent = false, -- Supresses vim.notify messages
        autoload_telescope = true, -- Automatically loads the telescope extension at setup
        data_path = vim.fn.stdpath("data"), -- Path that monorepo.json gets saved to
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
}
