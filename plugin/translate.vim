" Author : skanehira <sho19921005@gmail.com>
" License: MIT

scriptencoding utf-8

if exists('g:loaded_translate')
  finish
endif

let g:loaded_translate = 1

command! -bang -range -nargs=? Translate call translate#translate("<bang>", <line1>, <line2>, <f-args>)

nnoremap <silent> <Plug>(Translate) :<C-u>Translate<CR>
vnoremap <silent> <Plug>(VTranslate) :Translate<CR>
