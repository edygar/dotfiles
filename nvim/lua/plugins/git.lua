return {
  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      preview_config = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        relative = "cursor",
        row = 0,
        col = 1,
      },
      signcolumn = true,
      numhl = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 0,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = require("config.icons").ui.ChevronLeft
        .. " <summary>, <author_time:%Y-%m-%d> - <author>",
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        map("n", "<leader>gg", gs.preview_hunk, "Preview Hunk")
        map("n", "]g", gs.next_hunk, "Next Hunk")
        map("n", "[g", gs.prev_hunk, "Prev Hunk")

        map("n", "<leader>ogb", gs.toggle_current_line_blame, "Toggle GitBlame")

        map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>gR", "<cmd>!git reset %<cr>", "Reset whole file")
        map("n", "<leader>gt", "<cmd>silent !git restore %<cr>", "Restore file")
        map("n", "<leader>gl", function()
          gs.diffthis("~")
        end)
        map("n", "<leader>ob", gs.toggle_current_line_blame, "Toggle current line blame")

        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        -- map("n", "<leader>gd", gs.diffthis, "Diff This")
        -- map("n", "<leader>gD", function()
        -- gs.diffthis("~")
        -- end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "ruifm/gitlinker.nvim",
    keys = {
      { "<leader>gy", nil, mode = "n", desc = "Get repository link to current line" },
      { "<leader>gy", nil, mode = "v", desc = "Get repository link to current line" },
    },
    opts = function()
      return {
        callbacks = {
          ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
        },
        opts = {
          -- remote = 'github', -- force the use of a specific remote
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = true,
          -- callback for what to do with the url
          action_callback = require("gitlinker.actions").copy_to_clipboard,
          -- print the url after performing the action
          print_url = false,
          -- mapping to call url generation
          mappings = "<leader>gy",
        },
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", mode = "n", desc = "Open diff view" },
      { "<leader>gD", "<cmd>DiffviewOpen master..HEAD<cr>", mode = "n", desc = "History since master" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", mode = "n", desc = "Open file git history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", mode = "n", desc = "Open Git history" },
      { "<leader>gh", "<cmd>'<,'>DiffviewFileHistory<cr>", mode = "v", desc = "Open file history" },
    },
    opts = function()
      local actions = require("diffview.actions")
      return {
        keymaps = {
          file_history_panel = {
            ["q"] = function()
              vim.cmd("DiffviewClose")
            end,
            ["<C-u>"] = actions.scroll_view(-8),
            ["<C-d>"] = actions.scroll_view(8),
            ["<up>"] = actions.select_prev_entry,
            ["K"] = actions.select_prev_entry,
            ["<down>"] = actions.select_next_entry,
            ["J"] = actions.select_next_entry,
          },

          file_panel = {
            ["q"] = function()
              vim.cmd("DiffviewClose")
            end,
            ["<C-u>"] = actions.scroll_view(-8),
            ["<C-d>"] = actions.scroll_view(8),
            ["<up>"] = actions.select_prev_entry,
            ["K"] = actions.select_prev_entry,
            ["<down>"] = actions.select_next_entry,
            ["J"] = actions.select_next_entry,
          },
        },
      }
    end,
  },
  {
    "awerebea/git-worktree.nvim",
    branch = "handle_changes_in_telescope_api",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      {
        "<Leader>fw",
        "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
        desc = "Change git Worktree",
        mode = { "n" },
      },
      {
        "<Leader>fW",
        "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
        desc = "Create git Worktree",
        mode = { "n" },
      },
    },
    opts = function()
      require("telescope").load_extension("git_worktree")
    end,
  },
}
