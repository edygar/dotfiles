vim.api.nvim_set_var("chadtree_settings", 
  {
    --
    -- theme
    --
    ["theme.text_colour_set"] = "nerdtree_syntax_dark",

    --
    -- Keymaps
    --
    ["keymap.primary"] = {"<enter>", "o"}, -- (o)pen
    ["keymap.select"] = {"<space>", "s"},
    ["keymap.v_split"] = {"vv"}, -- same binding as normal buffers
    ["keymap.h_split"] = {"ss"}, -- same binding as normal buffers
    ["keymap.clear_selection"] = {"<esc>", "S"},
    ["keymap.tertiary"] = { "t", "<m-enter>", "<middlemouse>" }, -- (t)ab
    ["keymap.trash"] = { }, -- no trash
    ["keymap.rename"] = { "m", "r" }, -- (m)ove or (r)ename
    ["keymap.change_dir"] = { "w" }, -- set (w)orking dir
  }
)
