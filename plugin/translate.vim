" Version: 0.0.1
" Author : skanehira <sho19921005@gmail.com>
" License: MIT

let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

if exists('g:autoloaded_translate')
    finish
endif

let g:autoloaded_translate = 1
let s:translate_bufname = "TRANSLATE RESULT"

function! translate#translate(bang, start, end, ...) abort
    let ln = "\n"
    if &ff == "dos"
        let ln = "\r\n"
    endif
    let text = join(getline(a:start, a:end), ln)
    if !empty(a:000)
        let text = a:000[0]
    endif

    if text == ""
        echoerr "text is empty"
        return
    endif

    let source_ = get(g:, "translate_source", "en")
    let target = get(g:, "translate_target","ja")

    let cmd = "gtran -text='".text."' -source=".source_." -target=".target
    if a:bang == '!'
        let cmd = "gtran -text='".text."' -source=".target." -target=".source_
    endif
    let result = trim(system(cmd))

    " get current buffer
    let currentw = bufnr('%')

    let winsize_ = get(g:,"translate_winsize", 10)
    if !bufexists(s:translate_bufname)
        " create new buffer
        execute str2nr(winsize_).'new' s:translate_bufname
    else
        " focus translate window
        let buf = bufnr(s:translate_bufname)
        if empty(win_findbuf(buf))
            execute str2nr(winsize_).'new|e' s:translate_bufname
        endif
        call win_gotoid(win_findbuf(buf)[0])
    endif

    " insert result
    silent % d _
    call setline(1, split(result, '\r\?\n'))

    " focus current window
    call win_gotoid(win_findbuf(currentw)[0])
endfunction

command! -bang -range -nargs=? Translate call translate#translate("<bang>", <line1>, <line2>, <f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
