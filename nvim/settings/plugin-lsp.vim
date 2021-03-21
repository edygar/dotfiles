lua require("custom.lsp")

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <C-k> :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>:lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>:lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>gsd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> [g :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> ]g :lua vim.lsp.diagnostic.goto_prev()<CR>

nmap <silent> g[ <C-O>
nmap <silent> g] <C-I>

augroup LSP_CUSTOMIZATION
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
augroup END

autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorMoved * lua vim.lsp.diagnostic.show_line_diagnostics()

