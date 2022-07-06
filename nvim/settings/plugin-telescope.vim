lua require('custom/telescope')

" Using lua functions
nmap <Leader>f [telescope]
nnoremap [telescope]f <cmd>Telescope find_files<cr>
nnoremap [telescope]d <cmd>Telescope diagnostics<cr>
nnoremap [telescope]R <cmd>Telescope resume<cr>
nnoremap [telescope]t <cmd>Telescope colorscheme<cr>
nnoremap [telescope]g <cmd>Telescope live_grep<cr>
nnoremap [telescope]b <cmd>lua require('custom/telescope').buffers()<CR>
nnoremap [telescope]e <cmd>lua require('custom/telescope').browse_current_folder()<CR>
nnoremap [telescope]E <cmd>Telescope file_browser<cr>
nnoremap [telescope]h <cmd>Telescope help_tags<cr>
nnoremap [telescope]c <cmd>Telescope commands<cr>
nnoremap [telescope]k <cmd>Telescope keymaps<cr>

nnoremap [telescope]q <cmd>Telescope quickfix<cr>
nnoremap [telescope]l <cmd>Telescope loclist<cr>
nnoremap [telescope]j <cmd>Telescope jumplist<cr>
nnoremap [telescope]r <cmd>Telescope registers<cr>
