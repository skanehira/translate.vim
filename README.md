# translate.vim
This is language translate plugin.

![](https://github.com/skanehira/translate.vim/blob/img/screenshots/translate.vim.gif?raw=true)

# Features
- translate
- support popup window

# Requirement
- [gtran](https://github.com/skanehira/gtran)
- vim 8.1.1513 or above

# Installtion
Add this repo using the plugin manager.
Ex: dein.vim

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
:Translate hello my name is gorilla
```

Toggle between resource and target to translate when using "!"
```vim
:Translate!
```

Translate selected lines
```vim
:'<,'>Translate
```

Auto translate mode enable
```vim
:AutoTranslateModeEnable
```

Switch source and target
```vim
:AutoTranslateModeEnable!
```

Auto translate mode enable
```vim
:AutoTranslateModeToggle
```

Switch source and target
```vim
:AutoTranslateModeToggle!
```

Auto translate mode disable
```vim
:AutoTranslateModeDisable
```

You can set translate source, target and result window size.
```vim
let g:translate_source = "en"
let g:translate_target = "ja"
let g:translate_winsize = 10
```

You can also set key mappings.
```vim
let g:translate_no_mappings = 1 " default 1
xmap <Space>tr <Plug>(VTranslate)
xmap <Space>tr <Plug>(VTranslateBang)
```

