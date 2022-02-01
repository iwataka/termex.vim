fu! termex#terminal(force_new, cmd, use_floatwin) abort
  let cmd = a:cmd
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
      call s:open_buffer(bufnr, a:use_floatwin)
    else
      exe printf('%s term://%s', g:termex_open_command, cmd)
    endif
  else
    let term_buf = term_bufs[0]
    " if the target terminal is already opened, do nothing
    if term_buf.bufnr == bufnr('%')
      return
    endif
    call s:open_buffer(term_buf.bufnr, a:use_floatwin)
  endif
endfu

fu! s:open_buffer(bufnr, use_floatwin) abort
  if a:use_floatwin && exists('*nvim_open_win')
    call s:nvim_open_win(a:bufnr)
  else
    let bufname = bufname(a:bufnr)
    exe printf('%s %s', g:termex_open_command, bufname)
  endif
endfu

fu! s:nvim_open_win(bufnr) abort
  let width = nvim_win_get_width(0)
  let height = nvim_win_get_height(0)
  let opts = {
        \ 'relative': 'win',
        \ 'width': float2nr(width*0.8),
        \ 'height': float2nr(height*0.8),
        \ 'col': float2nr(width*0.1),
        \ 'row': float2nr(height*0.1),
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \ 'border': 'none',
        \ }
  " update according to user-defined options if possible
  if has_key(g:, 'termex_nvim_open_win_opts')
    for [key, value] in items(g:termex_nvim_open_win_opts)
      let opts[key] = value
    endfor
  endif
  call nvim_open_win(a:bufnr, 1, opts)
endfu
