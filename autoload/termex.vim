fu! termex#vsplit(force_new, exec_cmd, count) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:false, s:open_cmd('vsplit', a:count), {})
endfu

fu! termex#split(force_new, exec_cmd, count) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:false, s:open_cmd('split', a:count), {})
endfu

fu! s:open_cmd(exec_cmd, count) abort
  if a:count == 0
    return a:exec_cmd
  else
    return printf('%d%s', a:count, a:exec_cmd)
  endif
endfu

fu! termex#edit(force_new, exec_cmd) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:false, 'edit', {})
endfu

fu! termex#float(force_new, exec_cmd, opts) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:true, 'edit', a:opts)
endfu

fu! termex#terminal(force_new, exec_cmd, use_floatwin, open_cmd, floatwin_opts) abort
  if a:use_floatwin && !exists('*nvim_open_win')
    call s:warn("You're trying to termianl in floating window, but not supported")
  endif
  let cmd = a:exec_cmd
  " use $SHELL if no command specified
  if empty(cmd)
    let cmd = expand('$SHELL')
  endif
  let bufs = getbufinfo({'bufloaded': 1})
  let term_bufs = filter(bufs, printf("v:val.name =~ '\\vterm://(.{-}//(\\d+:)?)?\\V%s'", cmd))
  if empty(term_bufs) || a:force_new
    if a:use_floatwin && exists('*nvim_open_win')
      let bufnr = bufadd(printf('term://%s', cmd))
      call nvim_buf_set_option(bufnr, 'buflisted', v:true)
      call bufload(bufnr)
      call s:open_buffer(bufnr, a:use_floatwin, a:open_cmd, a:floatwin_opts)
    else
      exe printf('%s term://%s', a:open_cmd, cmd)
    endif
  else
    let term_buf = term_bufs[0]
    " if the target terminal is already opened, do nothing
    if term_buf.bufnr == bufnr('%')
      return
    endif
    call s:open_buffer(term_buf.bufnr, a:use_floatwin, a:open_cmd, a:floatwin_opts)
  endif
endfu

fu! s:open_buffer(bufnr, use_floatwin, open_cmd, floatwin_opts) abort
  if a:use_floatwin && exists('*nvim_open_win')
    call s:nvim_open_win(a:bufnr, a:floatwin_opts)
  else
    let bufname = bufname(a:bufnr)
    exe printf('%s %s', a:open_cmd, bufname)
  endif
endfu

fu! s:nvim_open_win(bufnr, opts) abort
  let width = nvim_win_get_width(0)
  let height = nvim_win_get_height(0)
  let opts = a:opts
  if type(opts['width']) == v:t_func
    let opts['width'] = opts['width'](width)
  endif
  if type(opts['height']) == v:t_func
    let opts['height'] = opts['height'](height)
  endif
  if type(opts['col']) == v:t_func
    let opts['col'] = opts['col'](width)
  endif
  if type(opts['row']) == v:t_func
    let opts['row'] = opts['row'](height)
  endif
  " update according to user-defined options if possible
  if has_key(g:, 'termex_nvim_open_win_opts')
    for [key, value] in items(g:termex_nvim_open_win_opts)
      let opts[key] = value
    endfor
  endif
  call nvim_open_win(a:bufnr, 1, opts)
endfu

function! s:warn(msg) abort
  call s:echomsg('WarningMsg', a:msg)
endfunction
