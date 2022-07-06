local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local Module = {}


local close_buffer = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selection = picker:get_multi_selection()

  if #selection == 1 then
    selection[1] = action_state.get_selected_entry()
  end

  for _, entry in ipairs(selection) do
    vim.cmd("Bdelete " .. entry.value)
  end

  actions.close(prompt_bufnr)
  Module.buffers()
end

telescope.setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    path_display = { "smart" },

    selection_caret = " ",
    prompt_prefix = " ",
    color_devicons = true,

    sorting_strategy = "ascending",
    prompt_position = "top",

    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },

      file_browser = {
        hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
      }
    },

    mappings = {
      i = {
        ["<C-q>"] = function(prompt_bufnr)
          actions.send_to_qflist(prompt_bufnr)
          builtin.quickfix()
        end,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev
      }
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension 'fzf'

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension "file_browser"

-- Loads the devicons
require 'nvim-web-devicons'.setup {
  default = true;
}

require('dressing').setup {
  input = {
    -- When true, <Esc> will not close the modal
    insert_only = false,
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = true,

    -- Priority list of preferred vim.select implementations
    backend = { "telescope", "fzf_lua", "fzf", "builtin" },

    -- Trim trailing `:` from prompt
    trim_prompt = true,
  }
}

Module.buffers = function(opts)
  opts = opts or {}
  builtin.buffers(vim.tbl_extend("force", {
    attach_mappings = function(_, map)
      map('n', 'd', close_buffer)
      map('i', '<C-x>', close_buffer)
      map('n', '<C-x>', close_buffer)
      return true
    end
  }, opts))
end


Module.browse_current_folder = function()
  require 'telescope'.extensions.file_browser.file_browser({
    ["cwd"] = vim.fn.expand("%:h")
  })
end

return Module
