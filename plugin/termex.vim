if &compatible || (exists('g:loaded_termex') && g:loaded_termex)
  finish
endif
let g:loaded_termex = 1

if !exists('g:termex_nvim_open_win_opts')
  let g:termex_nvim_open_win_opts = {
        \ 'relative': 'win',
        \ 'width': {w -> float2nr(w*0.8)},
        \ 'height': {h -> float2nr(h*0.8)},
        \ 'col': {w -> float2nr(w*0.1)},
        \ 'row': {h -> float2nr(h*0.1)},
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \ 'border': 'none',
        \ }
endif

if !exists('g:termex_sync_cwd')
  " EXPERIMENTAL FEATURE TO SYNC CWD
  let g:termex_sync_cwd = 0
endif

com! -nargs=* -bang -complete=shellcmd Term call
      \ termex#edit(<bang>0, <q-args>, g:termex_sync_cwd)
com! -nargs=* -bang -complete=shellcmd -count STerm call
      \ termex#split(<bang>0, <q-args>, <count>, g:termex_sync_cwd)
com! -nargs=* -bang -complete=shellcmd -count VTerm call
      \ termex#vsplit(<bang>0, <q-args>, <count>, g:termex_sync_cwd)
com! -nargs=* -bang -complete=shellcmd FTerm call
      \ termex#float(<bang>0, <q-args>, g:termex_nvim_open_win_opts, g:termex_sync_cwd)
