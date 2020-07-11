" Author : skanehira <sho19921005@gmail.com>
" License: MIT

scriptencoding utf-8

if has('nvim')
  echohl ErrorMsg
  echo '[transalte.vim] doesn''t support neovim'
  echohl None
  finish
endif

if exists('g:loaded_translate') || has('nvim')
  finish
endif

let g:loaded_translate = 1

command! -bang -range -nargs=? Translate call translate#translate("<bang>", <line1>, <line2>, <f-args>)

nnoremap <silent> <Plug>(Translate) :<C-u>Translate<CR>
vnoremap <silent> <Plug>(VTranslate) :Translate<CR>
