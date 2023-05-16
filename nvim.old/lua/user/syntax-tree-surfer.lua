local M = {}

M.config = function()
  require("syntax-tree-surfer").setup()
  local keymap = vim.keymap.set

  -- Syntax Tree Surfer
  local opts = { noremap = true, silent = true, nowait = true }

  -- Normal Mode Swapping:
  -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
  keymap("n", "[E", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })

  keymap("n", "]E", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })

  -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
  keymap("n", "}e", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })
  keymap("n", "{e", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })

  -- Visual Selection from Normal Mode
  keymap("n", "vV", "<cmd>STSSelectMasterNode<cr>", opts)
  keymap("n", "vv", "<cmd>STSSelectCurrentNode<cr>", opts)

  -- Select Nodes in Visual Mode
  keymap("x", "<Down>", "<cmd>STSSelectNextSiblingNode<cr>", opts)
  keymap("x", "<Up>", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
  keymap("x", "<Right>", "<cmd>STSSelectChildNode<cr>", opts)
  keymap("x", "<Left>", "<cmd>STSSelectParentNode<cr>", opts)

  keymap("x", "<C-A-j>", "<cmd>STSSelectNextSiblingNode<cr>", opts)
  keymap("x", "<C-A-k>", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
  keymap("x", "<C-A-l>", "<cmd>STSSelectChildNode<cr>", opts)
  keymap("x", "<C-A-h>", "<cmd>STSSelectParentNode<cr>", opts)

  -- Swapping Nodes in Visual Mode
  keymap("x", "[E", "`<<esc>[e", { silent = true, expr = true })
  keymap("x", "]E", "`<<esc>]e", { silent = true, expr = true })
end

return M
