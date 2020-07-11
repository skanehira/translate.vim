# translate.vim
This is translate language plugin.

![](https://i.imgur.com/p3WsE8P.gif)

# Features
- translate

# Requirement
- curl
- vim 8.1.1513 or above

# Installtion
You can use the plugin manager or Vim8 package manager.
eg: dein.vim

```toml
[[plugins]]
repo = 'skanehira/translate.vim'
```

# Usage
The default is to translate English into Japanese.

The language code is bellow.
https://cloud.google.com/translate/docs/languages

Translate current line
```vim
:Translate
```

Translate specified words
```vim
" result: こんにちは私の名前はゴリラです
:Translate hello my name is gorilla
```

Reverse between resource and target to translate when using "!"
```vim
" result: It's a gorilla
:Translate! ゴリラです
```

Translate selected lines
```vim
:'<,'>Translate
```

You can use below options
```vim
let g:translate_source = "en"
let g:translate_target = "ja"
let g:translate_popup_window = 0 " if you want use popup window, set value 1
let g:translate_winsize = 10 " set buffer window height size if you doesn't use popup window
```

You can also set key mappings.

```vim
nmap gr <Plug>(Translate)
vmap t <Plug>(VTranslate)
```

If you using popup window and you want yank translate result, you can use `y` to do it.
