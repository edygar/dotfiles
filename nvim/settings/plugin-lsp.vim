lua require("custom.lsp")

nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD :lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gH :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
inoremap <silent> <C-k> :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gca :lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gsd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gll :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})<CR>
nnoremap <silent> gff :lua vim.lsp.buf.formatting()<CR>

nnoremap <silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>

augroup LSP_CUSTOMIZATION
  autocmd! *
  autocmd BufWritePre * lua vim.lsp.buf.formatting()
  autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
augroup END

