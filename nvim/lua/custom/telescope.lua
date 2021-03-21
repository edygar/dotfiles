local actions = require('telescope.actions')

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
        ["<C-s>"] = actions.select_horizontal,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous
      }
    }
  }
}

require'nvim-web-devicons'.setup {
  default = true;
}

require('telescope').load_extension('fzy_native')
