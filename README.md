# translate.vim
This is language translate plugin.

![](https://i.imgur.com/lwplmKF.gif)
![](https://i.imgur.com/P0AJJBJ.gif)
![](https://i.imgur.com/ezLCrSG.gif)

# Features
- translate
- support popup window in vim 8.1.1444

# Requirement
- [gtran](https://github.com/skanehira/gtran)

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

