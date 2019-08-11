" Version: 0.0.2
" Author : skanehira <sho19921005@gmail.com>
" License: MIT

let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

if exists('g:loaded_translate')
	finish
endif

let g:loaded_translate = 1

command! -bang -range -nargs=? Translate call translate#translate("<bang>", <line1>, <line2>, <f-args>)
command! -bang -nargs=0 AutoTranslateModeEnable call translate#autoTranslateModeEnable("<bang>")
command! -bang -nargs=0 AutoTranslateModeDisable call translate#autoTranslateModeDisable("<bang>")
command! -bang -nargs=0 AutoTranslateModeToggle call translate#autoTranslateModeToggle("<bang>")

let &cpo = s:save_cpo
unlet s:save_cpo
