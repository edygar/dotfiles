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

      -- Table to store directories for each tab
      local tab_dirs = {}

      -- Autocmd for DirChanged
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          local current_tab = vim.api.nvim_get_current_tabpage()
          local current_dir = vim.fn.getcwd()
          tab_dirs[current_tab] = current_dir
        end,
      })

      -- Autocmd for TabEnter
      vim.api.nvim_create_autocmd("TabEnter", {
        callback = function()
          local current_tab = vim.api.nvim_get_current_tabpage()
          local dir_to_set = tab_dirs[current_tab]
          if dir_to_set then
            vim.api.nvim_set_current_dir(dir_to_set)
          end
        end,
      })

      -- Optional: Clear stored directory when a tab is closed
      vim.api.nvim_create_autocmd("TabClosed", {
        callback = function(args)
          tab_dirs[tonumber(args.tab)] = nil
        end,
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "okuuva/auto-save.nvim",
    keys = {
      {
        "<leader>ots",
        "<cmd>ASToggle<CR>",
        mode = "n",
        desc = "Toggle auto save",
      },
    },
    lazy = false,
    config = {
      enabled = true,
      execution_message = {
        enabled = false,
      },
      debounce_delay = 500,
      noautocmd = true,
      condition = function()
        return #vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.ERROR } }) == 0
      end,
      trigger_events = { -- See :h events
        immediate_save = { "BufLeave", "FocusLost", "InsertLeave" }, -- vim events that trigger an immediate save
        defer_save = { "TextChanged", "CursorHoldI" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
      },
    },
  },
}
