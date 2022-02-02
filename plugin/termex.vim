if &compatible || (exists('g:loaded_termex') && g:loaded_termex)
  finish
endif
let g:loaded_termex = 1

let g:termex_open_command = '20sp'
let g:termex_use_floatwin = v:false
let g:termex_nvim_open_win_opts = {}

com! -nargs=* -bang -complete=shellcmd Terminal call termex#terminal(
      \ <bang>0, <q-args>, g:termex_use_floatwin, g:termex_open_command)
