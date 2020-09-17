try
  " Define mappings
  autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> P denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> s denite#do_map('do_action', 'splitswitch')
    nnoremap <silent><buffer><expr> v denite#do_map('do_action', 'vsplitswitch')
    nnoremap <silent><buffer><expr> t denite#do_map('do_action', 'tabswitch')
    nnoremap <silent><buffer><expr> o denite#do_map('do_action', 'switch')
    nnoremap <silent><buffer><expr> <ESC> denite#do_map('quit')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
  endfunction

  autocmd FileType denite-filter call s:denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    setlocal nonumber norelativenumber
    inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    inoremap <silent><buffer><expr> <C-d> denite#do_map('do_action', 'delete')
    inoremap <silent><buffer><expr> <C-p> denite#do_map('do_action', 'preview')
    inoremap <silent><buffer><expr> <C-s> denite#do_map('do_action', 'splitswitch')
    inoremap <silent><buffer><expr> <C-v> denite#do_map('do_action', 'vsplitswitch')
    inoremap <silent><buffer><expr> <C-t> denite#do_map('do_action', 'tabswitch')
    inoremap <silent><buffer><expr> <C-o> denite#do_map('do_action', 'switch')
    inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    imap <silent><buffer> <ESC> <Plug>(denite_filter_quit)
  endfunction

	autocmd User denite-preview call s:denite_preview()
	function! s:denite_preview() abort
    setlocal relativenumber number
	endfunction


  " Use ripgrep for searching current directory for files
  " By default, ripgrep will respect rules in .gitignore
  "   --files: Print each file that would be searched (but don't search)
  "   --glob:  Include or exclues files for searching that match the given glob
  "            (aka ignore .git files)
  "
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

  " Use ripgrep in place of "grep"
  call denite#custom#var('grep', 'command', ['rg'])

  " Custom options for ripgrep
  "   --vimgrep:  Show results with every match on it's own line
  "   --hidden:   Search hidden directories and files
  "   --heading:  Show the file name above clusters of matches from each file
  "   --S:        Search case insensitively if the pattern is all lowercase
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

  " Recommended defaults for ripgrep via Denite docs
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')

  " Custom options for Denite
  let s:denite_options = {}
  let s:denite_options.default = {
  \ 'vertical_preview': v:true,
  \ 'auto_highlight': v:true,
  \ 'prompt': ' ',
  \ 'direction': 'dynamicbottom',
  \ 'highlight_mode_insert': 'Underline',
  \ 'highlight_mode_normal': 'CursorLine',
  \ 'highlight_prompt': 'Identifier',
  \ 'highlight_matched_char': 'Search',
  \ 'highlight_matched_range': 'NormalFloat',
  \ 'highlight_filter_background': 'String',
  \ 'highlight_window_background': 'NormalFloat',
  \ 'smartcase': v:true,
  \ 'start_filter': v:true,
  \ 'statusline': v:false,
  \ 'default_action': 'switch',
  \ 'split': 'horizontal',
  \ 'preview_width': &columns / 2,
  \ }

  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction

  call s:profile(s:denite_options)

  " MAPPINGS:
  " Mnemonic: *F*ind *F*iles
  nnoremap <leader>ff :Denite file/rec<CR>
  " Mnemonic: *F*ind *B*uffers
  nnoremap <leader>fb :Denite buffer<CR>
  " Mnemonic: *F*ind by *G*reping
  nnoremap <leader>fg :<C-U>Denite grep:. -no-empty -source-names=short -auto-action=preview<CR>
  " Mnemonic: *F*ind usages of *T*his file
  vnoremap <leader>ft :<C-U>exec 'Denite -input="' . expand("%:t:r") . '" grep:. -no-start-filter' -auto-action=preview<CR>

  "Mnemonic: `j` is like clicking a link (down).
  vnoremap <leader>j :<C-U>exec 'Denite -input="' . GetVisual() . '" grep:. -no-start-filter' -auto-action=preview<CR>
  nnoremap <leader>j :<C-U>DeniteCursorWord grep:. -no-start-filter<CR>

catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry
