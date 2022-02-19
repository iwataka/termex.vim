if &compatible || (exists('g:loaded_termex') && g:loaded_termex)
  finish
endif
let g:loaded_termex = 1

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

com! -nargs=* -bang -complete=shellcmd Term call
      \ termex#edit(<bang>0, <q-args>)
com! -nargs=* -bang -complete=shellcmd -count STerm call
      \ termex#split(<bang>0, <q-args>, <count>)
com! -nargs=* -bang -complete=shellcmd -count VTerm call
      \ termex#vsplit(<bang>0, <q-args>, <count>)
com! -nargs=* -bang -complete=shellcmd FTerm call
      \ termex#float(<bang>0, <q-args>, g:termex_nvim_open_win_opts)
