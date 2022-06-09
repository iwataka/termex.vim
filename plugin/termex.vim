if &compatible || (exists('g:loaded_termex') && g:loaded_termex)
  finish
endif
let g:loaded_termex = 1

if !exists('g:termex_nvim_open_win_opts')
  let g:termex_nvim_open_win_opts = {
        \ 'relative': 'editor',
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
      \ termex#edit(<q-args>, <bang>0, g:termex_sync_cwd, v:false)
com! -nargs=* -bang -complete=shellcmd -count STerm call
      \ termex#split(<q-args>, <bang>0, g:termex_sync_cwd, v:false, <count>)
com! -nargs=* -bang -complete=shellcmd -count VTerm call
      \ termex#vsplit(<q-args>, <bang>0, g:termex_sync_cwd, v:false, <count>)
com! -nargs=* -bang -complete=shellcmd FTerm call
      \ termex#float(<q-args>, <bang>0, g:termex_sync_cwd, v:false, g:termex_nvim_open_win_opts)

com! -nargs=+ -complete=shellcmd Tui call
      \ termex#edit(<q-args>, 1, 0, v:true)
com! -nargs=+ -complete=shellcmd -count STui call
      \ termex#split(<q-args>, 1, 0, v:true, <count>)
com! -nargs=+ -complete=shellcmd -count VTui call
      \ termex#vsplit(<q-args>, 1, 0, v:true, <count>)
com! -nargs=+ -complete=shellcmd FTui call
      \ termex#float(<q-args>, 1, 0, v:true, g:termex_nvim_open_win_opts)
