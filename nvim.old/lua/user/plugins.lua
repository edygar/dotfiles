local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

-- Have packer use a popup window
packer.init {
  snapshot_path = fn.stdpath "config" .. "/snapshots",
  max_jobs = 50,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded", -- Border style of prompt popups.
  },
}

return packer.startup(function(use)
  -- [Packer] -- Neovim Plugin Management
  use {
    "lewis6991/impatient.nvim",
    config = function()
      require("impatient").enable_profile()
    end,
  }
  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used ny lots of plugins
  use "christianchiarulli/lua-dev.nvim"

  -- [Essential] -- Plugins that are always loaded
  -- In general, plugins for file navigation/paginationplugin
  use {
    -- Toggle comments with ease
    "numToStr/Comment.nvim",
    config = function()
      require("user.comment").config()
    end,
  }

  use {
    "aserowy/tmux.nvim",
    config = function()
      require("user.tmux").config()
    end,
  }

  use {
    "phaazon/hop.nvim",
    config = function()
      require("hop").setup()
    end,
  } -- Jump to a file in the current directory
  use "Asheq/close-buffers.vim" -- Close buffers utility
  use "austintaylor/vim-indentobject" -- indentation as textobj
  use "tpope/vim-unimpaired" -- Mappings for e[ e] q[ q] l[ l], etc
  use "tpope/vim-repeat" -- Repeat last command
  use "andymass/vim-visput"
  use "kylechui/nvim-surround" -- Surround "" ()
  use "nacro90/numb.nvim" -- Peek line while :__
  use "NvChad/nvim-colorizer.lua" -- see colors in vim: #300

  -- [Optional] -- Plugins that are useful but not essential
  -- [Utility] -- Plugins that are useful but not essential
  use {
    "RRethy/vim-illuminate",
    commit = "6bfa5dc",
  } -- Highlight world under cursor
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "hoob3rt/lualine.nvim"

  use "vim-scripts/lastpos.vim" -- Passive. Last position jump improved.
  use "akinsho/toggleterm.nvim"
  use "lukas-reineke/indent-blankline.nvim"

  use "mbbill/undotree" -- Visualize your Vim undo tree
  use "monaqa/dial.nvim" --
  use "windwp/nvim-spectre" -- Search text panel
  use "kevinhwang91/nvim-bqf"
  use "ThePrimeagen/harpoon"
  use "MattesGroeger/vim-bookmarks"
  use "stevearc/qf_helper.nvim"

  use "knubie/vim-kitty-navigator"
  use {
    "vinnymeller/swagger-preview.nvim",
    run = "npm install -g swagger-ui-watcher",
  }
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  }

  -- UI
  use "stevearc/dressing.nvim"
  use "ghillb/cybu.nvim"
  use {
    "tversteeg/registers.nvim",
    config = function()
      require("user.registers").config()
    end,
  }
  use "rcarriga/nvim-notify"
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use {
    "goolord/alpha-nvim",
    config = function()
      require("user.alpha").config()
    end,
  }
  use "folke/which-key.nvim"
  use "folke/zen-mode.nvim"
  use "folke/todo-comments.nvim"
  use "andymass/vim-matchup"
  use "is0n/jaq-nvim"

  -- Colorschemes
  use "lunarvim/onedarker.nvim"

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path", -- path completions
      "hrsh7th/cmp-cmdline", -- cmdline completions
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-emoji",
      "zbirenbaum/copilot-cmp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      require("user.cmp").config()
    end,
  }

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  --
  --[[ use "williamboman/nvim-lsp-installer" -- simple to use language server installer ]]
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use "simrat39/symbols-outline.nvim"
  use "ray-x/lsp_signature.nvim"
  use "b0o/SchemaStore.nvim"
  use "folke/trouble.nvim"
  --[[ use "github/copilot.vim" ]]
  --[[ use { ]]
  --[[   "zbirenbaum/copilot.lua", ]]
  --[[   event = { "VimEnter" }, ]]
  --[[   config = function() ]]
  --[[     vim.defer_fn(function() ]]
  --[[       require("user.copilot").config() ]]
  --[[     end, 100) ]]
  --[[   end, ]]
  --[[ } ]]
  use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
  use "SmiteshP/nvim-navic"
  use "j-hui/fidget.nvim"

  -- TODO: set this up
  -- use "rmagatti/goto-preview"
  use "nvim-lua/lsp_extensions.nvim"

  -- MDX
  use "jxnblk/vim-mdx-js"

  -- Java
  use "mfussenegger/nvim-jdtls"

  -- Rust
  use { "christianchiarulli/rust-tools.nvim", branch = "handler_nil_check" }
  use "Saecki/crates.nvim"

  -- Typescript TODO: set this up, also add keybinds to ftplugin
  use {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("typescript").setup {}
    end,
  }

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"
  use "tom-anders/telescope-vim-bookmarks.nvim"
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    config = function()
      require("telescope").load_extension "fzf"
    end,
    run = "make",
    requires = "nvim-telescope/telescope.nvim",
  }

  use {
    "camgraff/telescope-tmux.nvim",
    config = function()
      require("telescope").load_extension "tmux"
    end,
  }

  -- Treesitter
  use "nvim-treesitter/nvim-treesitter"
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "nvim-treesitter/playground"
  use "windwp/nvim-ts-autotag"
  use {
    "ziontee113/syntax-tree-surfer",
    config = function()
      require("user.syntax-tree-surfer").config()
    end,
  }
  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("user.refactoring").config()
    end,
  }

  -- Git
  use "lewis6991/gitsigns.nvim"
  use "f-person/git-blame.nvim"
  use "ruifm/gitlinker.nvim"
  use "mattn/vim-gist"
  use {
    "sindrets/diffview.nvim",
    config = function()
      require("user.diffview").config()
    end,
  }
  use "mattn/webapi-vim"

  -- DAP
  use "mfussenegger/nvim-dap"
  use "jbyuki/one-small-step-for-vimkind"
  use "rcarriga/nvim-dap-ui"
  -- use "theHamsta/nvim-dap-virtual-text"

  -- Plugin Graveyard
  -- use "mizlan/iswap.nvim"
  -- use {'christianchiarulli/nvim-ts-rainbow'}
  -- use "nvim-telescope/telescope-ui-select.nvim"
  -- use "nvim-telescope/telescope-file-browser.nvim"
  -- use 'David-Kunz/cmp-npm' -- doesn't seem to work
  -- use "lunarvim/vim-solidity"
  -- use "tpope/vim-repeat"
  -- use "Shatur/neovim-session-manager"
  -- use "metakirby5/codi.vim"
  -- use { "nyngwang/NeoZoom.lua", branch = "neo-zoom-original" }
  -- use "rcarriga/cmp-dap"
  -- use "filipdutescu/renamer.nvim"
  -- use "https://github.com/rhysd/conflict-marker.vim"
  -- use "rebelot/kanagawa.nvim"
  -- use "unblevable/quick-scope"
  -- use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  -- use "gbprod/cutlass.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
