local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local Module = {}


local close_buffer = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selection = picker:get_multi_selection()

  if type(next(selection)) == "nil" then
    selection[1] = action_state.get_selected_entry()
  end

  for _, entry in ipairs(selection) do
    vim.cmd("Bdelete " .. entry.value)
  end

  actions.close(prompt_bufnr)
  Module.buffers()
end

require('telescope').setup{
  defaults = {
    file_sorter =  require('telescope.sorters').get_fzy_sorter,

    selection_caret = " ",
    prompt_prefix = " ",
    color_devicons = true,

    sorting_strategy = "ascending",
    prompt_position = "top",

    extensions = {
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      }
    },

    mappings = {
      n = {
        ["<space>"] = actions.toggle_selection,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-x>"] = false
      },
      i = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-x>"] = false
      }
    }
  }
}

require'nvim-web-devicons'.setup {
  default = true;
}

require('telescope').load_extension('fzy_native')


Module.buffers = function(opts)
  opts = opts or {}
  builtin.buffers(vim.tbl_extend("force", {
    attach_mappings = function(prompt_bufnr, map)
      map('n', 'd', close_buffer)
      map('i', '<C-x>', close_buffer)
      map('n', '<C-x>', close_buffer)
      return true
    end
  }, opts))
end


Module.browse_current_folder = function()
  builtin.file_browser({
    ["cwd"] = vim.fn.expand("%:h")
  })
end

return Module
