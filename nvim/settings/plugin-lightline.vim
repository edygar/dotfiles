let g:lightline = {
   \ 'colorscheme': 'gruvbox',
   \ 'mode_map': { 'c': 'NORMAL' },
   \ 'active': {
   \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
   \ },
   \ 'component_function': {
   \   'modified': 'MyModified',
   \   'readonly': 'MyReadonly',
   \   'fugitive': 'MyFugitive',
   \   'filename': 'MyFilename',
   \   'fileformat': 'MyFileformat',
   \   'filetype': 'MyFiletype',
   \   'fileencoding': 'MyFileencoding',
   \   'mode': 'MyMode',
   \ },
   \ 'separator': { 'left': '⮀', 'right': '⮂' },
   \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
\ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'denite' ? denite#get_status('sources') :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! MyFileformat()
  return '' " Experimenting leaving without this section for now (it almost never changes...)
  return winwidth(0) > 70 ? &fileformat : ''
  " return winwidth(0) > 70 ? &fileformat . ' ' . WebDevIconsGetFileFormatSymbol() : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileencoding()
  return '' " Experimenting leaving without this section for now (it almost never changes...)
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  if &ft == 'denite'
    let mode_str = substitute(denite#get_status('sources'), "-\\| ", "", "g")
    call lightline#link(tolower(mode_str[0]))
    return mode_str
  else
    return winwidth('.') > 60 ? lightline#mode() : ''
  endif
endfunction
