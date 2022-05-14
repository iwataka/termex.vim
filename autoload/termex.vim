fu! termex#vsplit(force_new, exec_cmd, count, sync_cwd) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:false, s:open_cmd('vsplit', a:count), {}, a:sync_cwd)
endfu

fu! termex#split(force_new, exec_cmd, count, sync_cwd) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:false, s:open_cmd('split', a:count), {}, a:sync_cwd)
endfu

fu! s:open_cmd(exec_cmd, count) abort
  if a:count == 0
    return a:exec_cmd
  else
    return printf('%d%s', a:count, a:exec_cmd)
  endif
endfu

fu! termex#edit(force_new, exec_cmd, sync_cwd) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:false, 'edit', {}, a:sync_cwd)
endfu

fu! termex#float(force_new, exec_cmd, opts, sync_cwd) abort
  call termex#terminal(a:force_new, a:exec_cmd, v:true, 'edit', a:opts, a:sync_cwd)
  if has_key(g:, 'termex_winblend')
    exe printf('setlocal winblend=%d', g:termex_winblend)
  endif
endfu

fu! termex#terminal(force_new, exec_cmd, use_floatwin, open_cmd, floatwin_opts, sync_cwd) abort
  if a:use_floatwin && !exists('*nvim_open_win')
    call s:warn("You're trying to termianl in floating window, but not supported")
  endif
  if a:exec_cmd == '?'
    let cmd = s:select_terminal(a:use_floatwin, a:open_cmd, a:floatwin_opts, a:sync_cwd)
  else
    let cmd = s:open_terminal(a:force_new, a:exec_cmd, a:use_floatwin, a:open_cmd, a:floatwin_opts, a:sync_cwd)
  endif
  if cmd == expand('$SHELL') && a:sync_cwd
    augroup termex
      autocmd!
      autocmd BufEnter <buffer> call termex#sync_cwd()
    augroup END
  endif
endfu

" Return an executed command
fu! s:open_terminal(force_new, exec_cmd, use_floatwin, open_cmd, floatwin_opts, sync_cwd) abort
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
      return ''
    endif
    call s:open_buffer(term_buf.bufnr, a:use_floatwin, a:open_cmd, a:floatwin_opts)
  endif
  return cmd
endfu

" Return an executed command
fu! s:select_terminal(use_floatwin, open_cmd, floatwin_opts, sync_cwd) abort
  let term_bufs = getbufinfo({'bufloaded': 1})
  let term_bufs = filter(term_bufs, "v:val.name =~ '\\vterm://(.{-}//(\\d+:)?)?.*'")
  if len(term_bufs) == 0
    " there's no terminal buffer yet
    return ''
  endif
  if len(term_bufs) == 1
    " there's only one terminal buffer
    let buf = term_bufs[0]
  else
    " there're multiple terminal buffers
    let term_buf_names = map(term_bufs[:], 'v:val.name')
    let input_cands = []
    for i in range(len(term_buf_names))
      call add(input_cands, printf("%d. %s", i + 1, term_buf_names[i]))
    endfor
    call inputsave()
    let selected_cand = inputlist(["Select terminal:"] + input_cands)
    call inputrestore()
    if selected_cand == ""
      return ''
    endif
    if len(term_bufs) < selected_cand
      call s:warn(printf("Invalid input: %s", selected_cand))
      return ''
    endif
    let buf = term_bufs[selected_cand - 1]
  endif
  call s:open_buffer(buf.bufnr, a:use_floatwin, a:open_cmd, a:floatwin_opts)
  return substitute(buf.name, '\vterm://(.{-}//(\d+:)?)?(.*)', '\3', '')
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

fu! s:warn(msg) abort
  echohl WarningMsg
  echo a:msg
  echohl Normal
endfu

fu! termex#sync_cwd() abort
  let cmd = printf("cd '%s'", getcwd())
  let job_id = b:terminal_job_id
  call chansend(job_id, printf("\<c-u>%s\<cr>", cmd))
endfu
