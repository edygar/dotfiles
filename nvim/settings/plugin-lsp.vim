lua require("custom.lsp")

nnoremap <silent> gd <cmd>lua require('telescope.builtin').lsp_definitions()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gH <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gsd <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gl <cmd>lua vim.lsp.diagnostic.set_loclist({open_loclist = true})<CR>
nnoremap <silent> gq <cmd>lua vim.lsp.diagnostic.set_qflist({open_loclist = true})<CR>
nnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.formatting()<CR>
xnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.range_formatting()<CR>

nnoremap <silent> gca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>

nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>d <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
inoremap <silent> <C-k> <cmd>lua vim.lsp.buf.hover()<CR>

nnoremap <silent> [g <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

augroup LSP_CUSTOMIZATION
  autocmd! *
  autocmd BufWritePre * lua vim.lsp.buf.formatting()
augroup END

augroup filetype_jsx
    autocmd!
    autocmd FileType javascript set filetype=typescriptreact
    autocmd FileType javascript LspStart typescript
    autocmd FileType javascript LspStart efm
augroup END
