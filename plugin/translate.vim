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

let g:translate_source = "en"
let g:translate_target = "ja"
let g:translate_winsize = 10

function! translate#translate(bang, start, end, ...) abort
    let text = join(getline(a:start, a:end), " ")
    if !empty(a:000)
        let text = a:000[0]
    endif

    if text == ""
        echoerr "text is empty"
        return
    endif

    let cmd = "gtran -text='".text."' -source=".g:translate_source." -target=".g:translate_target
    if a:bang == '!'
        let cmd = "gtran -text='".text."' -source=".g:translate_target." -target=".g:translate_source
    endif
    let result = trim(system(cmd))

    " get current buffer
    let currentw = bufnr('%')

    if !bufexists(s:translate_bufname)
        " create new buffer
        execute str2nr(g:translate_winsize, 10).'new' s:translate_bufname
    else
        " focus translate window
        let buf = bufnr(s:translate_bufname)
        if empty(win_findbuf(buf))
            execute str2nr(g:translate_winsize, 10).'new|e' s:translate_bufname
        endif
        call win_gotoid(win_findbuf(buf)[0])
    endif

    " insert result
    execute ':%d'
    call append(0, result)

    " focus current window
    call win_gotoid(win_findbuf(currentw)[0])
endfunction

command! -bang -range -nargs=? Translate call translate#translate("<bang>", <line1>, <line2>, <f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
