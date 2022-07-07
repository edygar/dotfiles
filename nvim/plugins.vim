if (!has('nvim'))
  " Make traditional vim aware of this folder so Plug can install itself in
  " there as well
  let &rtp = &rtp . ',  ~/.local/share/nvim/site/'
endif

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif

call plug#begin('~/.local/share/nvim/site/plugged')
"======================================="
"               Libraries               "
"======================================="
Plug 'nvim-lua/popup.nvim' " Required by telescope
Plug 'nvim-lua/plenary.nvim' " Required by popup.nvim
Plug 'RishabhRD/popfix' " Required by lsputils
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

"======================================="
"     Movement & editation plugins      "
"======================================="
Plug 'tpope/vim-repeat' " Use `.` to repeat surround and other commands
Plug 'tpope/vim-surround' " (o_o) -> ca([ -> [o_o]
Plug 'scrooloose/nerdcommenter' " Comments
Plug 'vim-scripts/lastpos.vim' " Passive. Last position jump improved.
Plug 'nelstrom/vim-visual-star-search' " Start a * or # search from a visual block
Plug 'tpope/vim-unimpaired' " Mappings for e[ e] q[ q] l[ l], etc
Plug 'jiangmiao/auto-pairs' " Matching parens, quotes etc.
Plug 'terryma/vim-multiple-cursors' " Multiple-cursor a la Sublime Text
Plug 'mattn/emmet-vim' " Expansion for HTML 

Plug 'austintaylor/vim-indentobject' " indentation as textobj
Plug 'kana/vim-textobj-user' " required by the some of the other textobjects above
Plug 'lucapette/vim-textobj-underscore'
Plug 'wellle/targets.vim' " provides additional text objects (see their full description!)

"======================================="
"               UI plugins              "
"======================================="
Plug 'gruvbox-community/gruvbox' " Colorscheme
Plug 'ryanoasis/vim-devicons' " Icons
Plug 'kyazdani42/nvim-web-devicons' " Icons
Plug 'itchyny/lightline.vim' " Nicer bar
Plug 'shinchu/lightline-gruvbox.vim' " Nicer bar theme
Plug 'Mofiqul/vscode.nvim' " VS Code theme
Plug 'flazz/vim-colorschemes'
Plug 'tjdevries/colorbuddy.vim'
Plug 'tjdevries/gruvbuddy.nvim'
Plug 'szw/vim-maximizer' " Maximizes and restores the current window

"======================================="
"             Syntax plugins            "
"======================================="
Plug 'powerman/vim-plugin-AnsiEsc' " Ensure ansi color codes are handled                
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Godly highlight (not yet)
Plug 'nvim-treesitter/playground'                                                       
Plug 'mattn/emmet-vim'

"======================================="
"      IDE (completion, debugging)      "
"======================================="
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig' " LSP configurations for builtin LSP client
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'
Plug 'hrsh7th/nvim-compe' " LSP Completion

"======================================="
"           Workflow plugins            "
"======================================="
Plug 'mbbill/undotree' " visualize your Vim undo tree
Plug 'skwp/greplace.vim' " search and edit globally
Plug 'christoomey/vim-tmux-navigator' " Seamless navigation between vim and tmux windows

" File tree
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Git
Plug 'gregsexton/gitv', {'on': ['Gitv']} " gitk for vim. Extends vim fugitive
Plug 'tpope/vim-fugitive' " Git commands and workflow for vim
Plug 'tpope/vim-git' " syntax, indent, and filetype plugin files for git related buffers

" Telescope
Plug 'nvim-telescope/telescope.nvim' " Better than fzf, amazing search
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

"======================================="
"    Experimental (testing plugins)     "
"======================================="
"
Plug 'moll/vim-bbye' " Better buffer management
Plug 'junegunn/vim-easy-align' " Align stuff
Plug 'stevearc/dressing.nvim' " Testing


call plug#end()

