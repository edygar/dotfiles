lua require("custom.lsp")

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD :lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <C-h> :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>:lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>:lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gsd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gll :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})<CR>

nnoremap <silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>

augroup LSP_CUSTOMIZATION
    autocmd!
    autocmd BufWinEnter,TabEnter,InsertLeave * lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
    " autocmd CursorHold,CursorMoved * lua vim.lsp.diagnostic.show_line_diagnostics()
augroup END
