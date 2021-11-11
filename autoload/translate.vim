" Author: skanehira <sho19921005@gmail.com>
" License: MIT

let s:endpoint = get(g:, "translate_endpoint", "https://script.google.com/macros/s/AKfycbywwDmlmQrNPYoxL90NCZYjoEzuzRcnRuUmFCPzEqG7VdWBAhU/exec")

let s:translate_bufname = "translate://result"
let s:last_popup_window = 0
let s:result = []
let s:echo_result = 0

function! s:echoerr(msg) abort
  echohl ErrorMsg
  echo "[translate.vim]" a:msg
  echohl None
endfunction

" translate
function! translate#translate(bang, start, end, echo_result = 0, ...) abort
  if !executable("curl")
    call s:echoerr("please install curl")
    return
  endif

  let ln = "\n"
  if &ff == "dos"
    let ln = "\r\n"
  endif

  let s:echo_result = a:echo_result

  let text = s:getline(a:start, a:end, ln, a:000)
  if empty(text)
    call s:echoerr("text is emtpy")
    return
  endif

  let cmd = s:create_cmd(text, a:bang)

  echo "Translating..."
  let s:result = []

  if has('nvim')
    call jobstart(cmd, {
          \ 'on_stdout': { id, data -> extend(s:result, data) },
          \ 'on_exit': { -> s:create_window() },
          \ })
  else
    call job_start(cmd, {
          \ "out_cb": function("s:tran_out_cb"),
          \ "err_cb": function("s:tran_out_cb"),
          \ "exit_cb": function("s:tran_exit_cb"),
          \ })
  endif
endfunction

" get text from selected lines or args
function! s:getline(start, end, ln, args) abort
  let text = getline(a:start, a:end)
  if !empty(a:args)
    let text = a:args
  endif

  return join(text, a:ln)
endfunction

" create curl command
function! s:create_cmd(text, bang) abort
  let source = get(g:, "translate_source", "en")
  let target = get(g:, "translate_target", "ja")

  let cmd = ["curl", "-s", "-L", s:endpoint, "-d"]
  if a:bang == '!'
    let body = json_encode({'source': target, 'target': source, 'text': a:text})
    let cmd = cmd + [body]
  else
    let body = json_encode({'source': source, 'target': target, 'text': a:text})
    let cmd = cmd + [body]
  endif
  return cmd
endfunction

" get command result
function! s:tran_out_cb(ch, msg) abort
  call add(s:result, a:msg)
endfunction

" set command result to translate window buffer
function! s:tran_exit_cb(job, status) abort
  call s:create_window()
endfunction

function! s:filter(id, key) abort
  if a:key ==# 'y'
    call setreg(v:register, s:result)
    call popup_close(a:id)
    return 1
  endif
endfunction

" create translate result window
function! s:create_window() abort
  echo ""
  if has('nvim')
    " EOF is a single-item list on neovim
    call remove(s:result, -1)
  endif
  if empty(s:result)
    call s:echoerr("no translate result")
    return
  endif

  if s:echo_result
      echo 'Translate result : ' . join(s:result, ' ')
      let s:echo_result = 0
  elseif get(g:, "translate_popup_window", 1)
    let max_height = len(s:result)
    let max_width = 10
    for str in s:result
      let length = strdisplaywidth(str)
      if  length > max_width
        let max_width = length
      endif
    endfor

    if exists("*popup_atcursor")
      call popup_close(s:last_popup_window)

      let pos = getpos(".")

      " 2 is border thickness
      let line = "cursor-" . printf("%d", max_height + 2)
      if pos[1] < max_height
        let line = "cursor+1"
      endif

      let s:last_popup_window = popup_atcursor(s:result, {
            \ "pos":"topleft",
            \ "border": [1, 1, 1, 1],
            \ "line": line,
            \ "maxwidth": max_width,
            \ 'borderchars': ['-','|','-','|','+','+','+','+'],
            \ "moved": "any",
            \ "filter": function("s:filter"),
            \ })
    elseif exists('*nvim_create_buf')
      let s:last_popup_bufid = nvim_create_buf(v:false, v:true)
      let opts = {
            \ 'relative': 'win',
            \ 'width': max_width,
            \ 'height': max_height,
            \ 'bufpos': [line("."), 0],
            \ 'row': -1,
            \ 'col': 0,
            \ 'style': 'minimal'
            \ }
      let s:last_popup_window = nvim_open_win(s:last_popup_bufid, 0, opts)
      call nvim_set_current_win(s:last_popup_window)
      noremap <buffer> <silent> q :bw!<CR>
      call nvim_buf_set_lines(s:last_popup_bufid, 0, -1, v:true, s:result)
    else
      call s:echoerr("this version doesn't support popup or floating window")
    endif
  else
    let current = win_getid()
    let winsize = get(g:,"translate_winsize", len(s:result) + 2)

    if !bufexists(s:translate_bufname)
      " create new buffer
      execute str2nr(winsize) . "new" s:translate_bufname
      set buftype=nofile
      set ft=translate
      nnoremap <silent> <buffer> q :<C-u>bwipeout!<CR>
    else
      " focus translate window
      let tranw = bufnr(s:translate_bufname)
      let winid = win_findbuf(tranw)
      if empty(winid)
        execute str2nr(winsize) . "new | e" s:translate_bufname
      else
        call win_gotoid(winid[0])
      endif
    endif

    " set tranlsate result
    silent % d _
    call setline(1, s:result)

    call win_gotoid(current)
  endif
endfunction
