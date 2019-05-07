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

let g:translate_source = "en"
let g:translate_target = "ja"
let s:translate_buf = "translated"

function! translate#translate(text) abort
    let result = system("gtran -text='".a:text."' -source=".g:translate_source." -target=".g:translate_target)

    " get current buffer
    let currentw = bufnr('%')

    if !bufexists(s:translate_buf)
        " create new buffer
        execute '20new' s:translate_buf
    else
        " focus translate window
        let buf = bufnr(s:translate_buf)
        if empty(win_findbuf(buf))
            execute '20new|e' s:translate_buf
        endif
        call win_gotoid(win_findbuf(buf)[0])
    endif

    " insert result
    execute ':%d | normal i' . result 

    " focus current window
    call win_gotoid(win_findbuf(currentw)[0])
endfunction

function! translate#translateSelected() abort
    let tmp = @@
    execute 'silent normal gvy'
    let selected = @@
    let @@ = tmp
    call translate#translate(selected)
endfunction

command! -nargs=1 Translate call translate#translate(<f-args>)
command! -range TranslateSelected call translate#translateSelected()

let &cpo = s:save_cpo
unlet s:save_cpo
