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

"======================================="
"     Movement & editation plugins      "
"======================================="
Plug 'tpope/vim-repeat' " Use `.` to repeat surrount and other commands
Plug 'tpope/vim-surround' " (o_o) -> ca([ -> [o_o]
Plug 'scrooloose/nerdcommenter' " Comments
Plug 'vim-scripts/lastpos.vim' " Passive. Last position jump improved.
Plug 'nelstrom/vim-visual-star-search' " Start a * or # search from a visual block
Plug 'tpope/vim-unimpaired' " Mappings for e[ e] q[ q] l[ l], etc
Plug 'terryma/vim-multiple-cursors' " Multiple-cursor a la Sublime Text
Plug 'mattn/emmet-vim' " Expansion for HTML 

Plug 'austintaylor/vim-indentobject' " indentation as textobj
Plug 'kana/vim-textobj-user' " required by the some of the other textobjects above
Plug 'lucapette/vim-textobj-underscore'
Plug 'wellle/targets.vim' " provides additional text objects (see their full description!)

"======================================="
"               UI plugins              "
"======================================="
Plug 'ryanoasis/vim-devicons' " Icons
Plug 'kyazdani42/nvim-web-devicons' " Icons
Plug 'itchyny/lightline.vim' " Nicer bar
Plug 'vim-airline/vim-airline' " Important info on bars
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox' " My current favorite colorscheme
Plug 'szw/vim-maximizer' " Maximizes and restores the current window

"======================================="
"             Syntax plugins            "
"======================================="
Plug 'powerman/vim-plugin-AnsiEsc' " Ensure ansi color codes are handled
Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mattn/emmet-vim'
Plug 'plasticboy/vim-markdown'
Plug 'jxnblk/vim-mdx-js'
Plug 'jparise/vim-graphql' 

"======================================="
"      IDE (completion, debugging)      "
"======================================="
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

"======================================="
"           Workflow plugins            "
"======================================="
Plug 'mbbill/undotree' " visualize your Vim undo tree

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
Plug 'nvim-telescope/telescope-fzy-native.nvim'

"======================================="
"    Experimental (testing plugins)     "
"======================================="
Plug 'moll/vim-bbye' " Better buffer management
Plug 'junegunn/vim-easy-align' " Align stuff

call plug#end()

