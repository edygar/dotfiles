set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap gd :lua vim.lsp.buf.definition()<CR>
nnoremap gi :lua vim.lsp.buf.implementation()<CR>
nnoremap gsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap grr :lua vim.lsp.buf.references()<CR>
nnoremap grn :lua vim.lsp.buf.rename()<CR>
nnoremap gh :lua vim.lsp.buf.hover()<CR>
nnoremap gca :lua vim.lsp.buf.code_action()<CR>
nnoremap gsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap [g :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap ]g :lua vim.lsp.diagnostic.set_loclist()<CR>

nmap <silent> g[ <C-O>
nmap <silent> g] <C-I>

augroup LSP_CUSTOMIZATION
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
augroup END
