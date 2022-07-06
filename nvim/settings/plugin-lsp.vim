lua require("custom.lsp")

nnoremap <silent> gd <cmd>Telescope lsp_definitions<CR>
nnoremap <silent> gD <cmd>Telescope lsp_type_definitions<CR>
nnoremap <silent> gi <cmd>Telescope lsp_implementations<CR>
nnoremap <silent> gH <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr <cmd>Telescope lsp_references<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gsd <cmd>lua vim.lsp.diagnostic.open_float()<CR>
nnoremap <silent> gl <cmd>lua vim.diagnostic.setloclist({ open = true })<CR>
nnoremap <silent> gq <cmd>lua vim.diagnostic.setqflist({ open = true })<CR>
nnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.formatting()<CR>
xnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.range_formatting()<CR>

nnoremap <silent> gca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>

nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>d <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
inoremap <silent> <C-k> <cmd>lua vim.lsp.buf.hover()<CR>

nnoremap <silent> [g <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g <cmd>lua vim.diagnostic.goto_next()<CR>


augroup LSP_FORMATTING
  autocmd!
  autocmd BufWritePre * if get(b:, 'auto_formatting_enabled', 1) | execute 'lua vim.lsp.buf.formatting()' | endif
augroup END

nnoremap <silent> <f4> :<c-u>let b:auto_formatting_enabled = !get(b:, 'auto_formatting_enabled', 1)<cr>
