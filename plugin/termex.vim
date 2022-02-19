if &compatible || (exists('g:loaded_termex') && g:loaded_termex)
  finish
endif
let g:loaded_termex = 1

let g:termex_nvim_open_win_opts = {}

com! -nargs=* -bang -complete=shellcmd Term call
      \ termex#edit(<bang>0, <q-args>)
com! -nargs=* -bang -complete=shellcmd -count STerm call
      \ termex#split(<bang>0, <q-args>, <count>)
com! -nargs=* -bang -complete=shellcmd -count VTerm call
      \ termex#vsplit(<bang>0, <q-args>, <count>)
com! -nargs=* -bang -complete=shellcmd FTerm call
      \ termex#float(<bang>0, <q-args>)
