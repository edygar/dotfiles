set relativenumber number
set diffopt+=vertical
set clipboard+=unnamedplus
set list listchars=tab:\ \ ,trail:·

set gcr=a:blinkon0  "Disable cursor blink
set visualbell      "No sounds

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================

" Keep undo history across sessions, by storing in file.
" Only works all the time.
set undofile

" ================ Indentation ======================

set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
" Some file types use real tabs
au FileType {make,gitconfig} set noexpandtab sw=4

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

set nowrap    "Don't wrap lines
set linebreak "Wrap lines at convenient points


" ================ Search ===========================

set ignorecase " Ignore case when searching...
set smartcase  " ...unless we type a capital

" ================ Formatting =======================
set formatoptions+=j " Delete comment character when joining commented lines

