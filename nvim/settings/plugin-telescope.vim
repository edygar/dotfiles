lua require('custom/telescope')

" Using lua functions
nmap <Leader>f [telescope]
nnoremap [telescope]f <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap [telescope]g <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap [telescope]b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap [telescope]e <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap [telescope]h <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap [telescope]c <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap [telescope]k <cmd>lua require('telescope.builtin').keymaps()<cr>


nnoremap [telescope]q <cmd>lua require('telescope.builtin').quickfix()<cr>
nnoremap [telescope]l <cmd>lua require('telescope.builtin').loclist()<cr>
nnoremap [telescope]r <cmd>lua require('telescope.builtin').registers()<cr>
