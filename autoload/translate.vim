" Version: 0.0.3
" Author: skanehira <sho19921005@gmail.com>
" License: MIT

let s:save_cpo = &cpo
set cpo&vim

let s:translate_bufname = "TRANSLATE RESULT"
" current window number
let s:currentw = ""
" command result
let s:result = []
" used in translate mode
let s:bang = ""
let s:current_mode = 0
let s:auto_trans_mode = 1
let s:last_popup_window = 0

" translate
function! translate#translate(bang, line1, line2, ...) abort
    let ln = "\n"
    if &ff == "dos"
        let ln = "\r\n"
    endif

    let s:result = []
    let start = a:line1
    let end = a:line2

    if s:current_mode == s:auto_trans_mode
        let start = 1
        let end = getpos("$")[1]
        let line = s:getline(start, end, ln, a:000)
        if empty(line)
            return
        endif
        let cmd = s:create_cmd(line, s:bang)
    else
        if empty(a:000)
            let text = s:getwords_last_visual(ln)
        else
            let text = join(a:000, ln)
        endif
        let cmd = s:create_cmd(text, a:bang)
    endif

    if empty(cmd)
        return
    endif

    if !executable(cmd[0])
        echohl ErrorMsg
        echomsg 'Please install gtrans command: https://github.com/skanehira/gtran'
        echohl None
        return
    endif

    echo "Translating..."
    let job = job_start(cmd, {
                \"callback": function("s:tran_out_cb"),
                \"exit_cb": function("s:tran_exit_cb"),
                \})
endfunction

" get text from selected lines or args
function! s:getline(start, end, ln, args) abort
    let text = getline(a:start, a:end)
    if !empty(a:args)
        let text = a:args
    endif

    if empty(text)
        return ""
    endif

    return join(text, a:ln)
endfunction

" get text from last selected words
function! s:getwords_last_visual(ln) abort
    let reg = '"'
    " save
    let save_reg = getreg(reg)
    let save_regtype = getregtype(reg)
    let save_ve = &virtualedit

    set virtualedit=

    silent exec 'normal! gv"'.reg."y"
    let lines = getreg(reg, 1, 1)

    " resotore
    call setreg(reg, save_reg, save_regtype)
    let &virtualedit = save_ve

    return join(lines, a:ln)
endfunction


" create gtran command with text and bang
function! s:create_cmd(text, bang) abort
    if a:text == ""
        return []
    endif

    let source_ = get(g:, "translate_source", "en")
    let target = get(g:, "translate_target", "ja")

    let cmd = ["gtran", "-text=".a:text, "-source=".source_, "-target=".target]
    if a:bang == '!'
        let cmd = ["gtran", "-text=".a:text, "-source=".target, "-target=".source_]
    endif
    return cmd
endfunction

" get command result
function! s:tran_out_cb(ch, msg) abort
    call add(s:result, a:msg)
endfunction

" set command result to translate window buffer
function! s:tran_exit_cb(job, status) abort
    call s:create_tran_window()
    call s:focus_window(s:currentw)
    echo ""
endfunction

" create translate result window
function! s:create_tran_window() abort
    let s:currentw = winnr()

    if has("patch-8.1.1513") && s:current_mode == 0
        call popup_close(s:last_popup_window)

        if !empty(s:result)
            let maxwidth = 30
            for str in s:result
                let length = len(str)
                if  length > maxwidth
                    let maxwidth = length
                endif
            endfor

            let pos = getpos(".")
            let result_height = len(s:result) + 2 " 2 is border thickness

            let line = "cursor-".printf("%d", result_height)
            if pos[1] <  result_height
                let line = "cursor+1"
            endif

            let s:last_popup_window = popup_create(s:result, {
                        \ "pos":"topleft",
                        \ "border": [1, 1, 1, 1],
                        \ "line":line,
                        \ "col":"cursor",
                        \ "maxwidth":maxwidth,
                        \ 'borderchars': ['-','|','-','|','+','+','+','+'],
                        \ "moved": "any",
                        \ })
        endif
    else
        let winsize_ = get(g:,"translate_winsize", 10)
        if !bufexists(s:translate_bufname)
            " create new buffer
            execute str2nr(winsize_) . "new" s:translate_bufname
        else
            " focus translate window
            let tranw = bufnr(s:translate_bufname)
            if empty(win_findbuf(tranw))
                execute str2nr(winsize_) . "new | e" s:translate_bufname
            endif
            "call s:focus_window(tranw)
        endif

        silent % d _
        if !empty(s:result)
            call setline(1, s:result)
        endif
    endif
endfunction

" close specified window
function! s:close_window(bid) abort
    execute "bw!" a:bid
    redraw
    echo "deleted"
endfunction

" focus spcified window.
" bid arg is buffer id that can use bufnr to get.
function! s:focus_window(winid) abort
    call win_gotoid(a:winid)
endfunction

" enable auto translate mode
function! translate#autoTranslateModeEnable(bang) abort
    if s:current_mode != s:auto_trans_mode
        inoremap <buffer> <CR> <C-o>:Translate<CR><CR>
        let s:current_mode = s:auto_trans_mode
        call s:create_tran_window()
        call s:focus_window(s:currentw)
        let s:bang = a:bang
    endif
endfunction

" disable auto translate mode
function! translate#autoTranslateModeDisable(bang) abort
    " set normal mode
    let s:current_mode = 0
    " reset result
    let s:result = []
    call s:close_window(bufnr(s:translate_bufname))
endfunction

" auto translate mode toggle
function! translate#autoTranslateModeToggle(bang) abort
    if s:current_mode == s:auto_trans_mode
        call translate#autoTranslateModeDisable(a:bang)
    else
        call translate#autoTranslateModeEnable(a:bang)
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
