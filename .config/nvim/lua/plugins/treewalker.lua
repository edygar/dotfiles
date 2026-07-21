local keys = {
  {
    "vv",
    function() require("custom.syntax_tree").select_current() end,
    mode = "n",
    desc = "Select current syntax node",
  },
  {
    "<Lt>L",
    function() return require("custom.syntax_tree").operator "up" end,
    mode = "n",
    expr = true,
    nowait = true,
    desc = "Swap with previous syntax node",
  },
  {
    ">L",
    function() return require("custom.syntax_tree").operator "down" end,
    mode = "n",
    expr = true,
    nowait = true,
    desc = "Swap with next syntax node",
  },
  {
    "<Lt>L",
    function() require("custom.syntax_tree").swap_visual "up" end,
    mode = "x",
    nowait = true,
    desc = "Swap selection with previous syntax node",
  },
  {
    ">L",
    function() require("custom.syntax_tree").swap_visual "down" end,
    mode = "x",
    nowait = true,
    desc = "Swap selection with next syntax node",
  },
}

local function add_selection_keys(mode, mappings)
  for lhs, mapping in pairs(mappings) do
    keys[#keys + 1] = {
      lhs,
      mode == "n" and function() require("custom.syntax_tree").select_current() end
        or "<Cmd>Treewalker " .. mapping[1] .. "<CR>",
      mode = mode,
      desc = mode == "n" and "Select current syntax node" or "Select " .. mapping[2] .. " syntax node",
    }
  end
end

-- Keep the complete syntax-tree-surfer keymap surface from the old config.
add_selection_keys("n", {
  ["<C-A-k>"] = { "Up", "current" },
  ["<C-A-j>"] = { "Down", "current" },
  ["<C-A-h>"] = { "Left", "current" },
  ["<C-A-l>"] = { "Right", "current" },
  ["<Up>"] = { "Up", "current" },
  ["<Down>"] = { "Down", "current" },
  ["<Left>"] = { "Left", "current" },
  ["<Right>"] = { "Right", "current" },
})

add_selection_keys("x", {
  ["<C-A-k>"] = { "Up", "previous" },
  ["<C-A-j>"] = { "Down", "next" },
  ["<C-A-h>"] = { "Left", "parent" },
  ["<C-A-l>"] = { "Right", "child" },
  ["<Up>"] = { "Up", "previous" },
  ["<Down>"] = { "Down", "next" },
  ["<Left>"] = { "Left", "parent" },
  ["<Right>"] = { "Right", "child" },
  ["<C-M-Left>"] = { "Up", "previous" },
  ["<C-M-Right>"] = { "Down", "next" },
  ["<C-M-Up>"] = { "Left", "parent" },
  ["<C-M-Down>"] = { "Right", "child" },
})

return {
  "aaronik/treewalker.nvim",
  opts = {
    select = true,
  },
  keys = keys,
}
