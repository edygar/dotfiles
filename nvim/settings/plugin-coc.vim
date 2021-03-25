" coc config
let g:coc_global_extensions = [
\ 'coc-eslint',
\ 'coc-tsserver',
\ 'coc-emmet',
\ 'coc-css',
\ 'coc-html',
\ 'coc-json',
\ 'coc-prettier',
\ 'coc-svg',
\ 'coc-lists',
\ 'coc-snippets',
\ 'coc-git',
\ 'coc-pairs',
\ 'coc-marketplace',
\ 'coc-stylelint',
\ 'coc-jest',
\ 'coc-project',
\ 'coc-vimlsp',
\ 'coc-phpls',
\ ]

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use `g[` and `g]` to navigate forward and backward
nmap <silent> g[ <C-O>
nmap <silent> g] <C-I>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>bf  <Plug>(coc-format-selected)
nmap <leader>bf  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact,json,graphql,css setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use Shift-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-Space> <Plug>(coc-range-select)
xmap <silent> <C-Space> <Plug>(coc-range-select)

" Prettier setup
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

hi default link CocWarningVirtualText CocWarningSign

hi CocWarningSign  ctermfg=Brown guifg=Orange

" nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gD :lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gH :lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
" nnoremap <silent> gR :lua vim.lsp.buf.rename()<CR>
" nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
" inoremap <silent> <C-k> :lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gca :lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent> gsd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
" nnoremap <silent> gll :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})<CR>
" nnoremap <silent> gff :lua vim.lsp.buf.formatting()<CR>
" 
" nnoremap <silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>
" nnoremap <silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>
" 
" augroup LSP_CUSTOMIZATION
"   autocmd! *
"   autocmd BufWritePre * lua vim.lsp.buf.formatting()
"   autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
" augroup END
" 
