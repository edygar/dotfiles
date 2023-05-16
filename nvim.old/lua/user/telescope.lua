local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    theme = "ivy",

    file_sorter = require("telescope.sorters").get_fzf_sorter,
    path_display = { "truncate" },

    selection_caret = "\u{e0b1} ",
    prompt_prefix = "\u{e0b1} ",
    color_devicons = true,

    sorting_strategy = "ascending",

    file_ignore_patterns = {
      "\\.git/",
      "target/",
      "docs/",
      "vendor/*",
      "%\\.lock",
      "__pycache__/*",
      "%\\.sqlite3",
      "%\\.ipynb",
      "node_modules/*",
      "%\\.jpg",
      "%\\.jpeg",
      "%\\.png",
      "%\\.svg",
      "%\\.otf",
      "%\\.ttf",
      "%\\.webp",
      "\\.dart_tool/",
      "\\.github/",
      "\\.gradle/",
      "\\.idea/",
      "\\.settings/",
      "\\.vscode/",
      "__pycache__/",
      "build/",
      "env/",
      "gradle/",
      "node_modules/",
      "%\\.pdb",
      "%\\.dll",
      "%\\.class",
      "%\\.exe",
      "%\\.cache",
      "%\\.ico",
      "%\\.pdf",
      "%\\.dylib",
      "%\\.jar",
      "%\\.docx",
      "%\\.met",
      "smalljre_*/*",
      "\\.vale/",
      "%\\.burp",
      "%\\.mp4",
      "%\\.mkv",
      "%\\.rar",
      "%\\.zip",
      "%\\.7z",
      "%\\.tar",
      "%\\.bz2",
      "%\\.epub",
      "%\\.flac",
      "%\\.tar\\.gz",
    },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-e>"] = require("user.nvim-tree").open_in_nvim_tree,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<c-x>"] = actions.delete_buffer,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

        ["<C-q>"] = function(bufnr)
          actions.send_to_qflist(bufnr)
          vim.cmd "UserTelescope quickfix"
        end,
        ["<M-q>"] = function(bufnr)
          actions.send_selected_to_qflist(bufnr)
          vim.cmd "UserTelescope quickfix"
        end,

        ["<esc><esc>"] = actions.close,
      },

      n = {
        ["<C-e>"] = require("user.nvim-tree").open_in_nvim_tree,
        ["<esc>"] = actions.close,
        ["<esc><esc>"] = actions.close,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.delete_buffer,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,
        ["q"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,
      },
    },
  },
  pickers = {
    buffers = {
      sort_mru = true,
    },
    oldfiles = {
      cwd_only = true,
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}

vim.api.nvim_create_user_command("UserTelescope", function(opt)
  vim.cmd("Telescope " .. opt.args .. " theme=ivy ")
end, { nargs = "?" })
