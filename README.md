# translate.vim
This is language translate plugin.

![](https://i.imgur.com/pQ3hKes.gif)

# Requirement
- [gtran](https://github.com/skanehira/gtran)

# Installtion
Add this repo to the plugin manager.  
Ex: dein.vim

```toml
[[plugins]]
repo = 'skanehira/translate.vim'
```

# Usage
The default is to translate English into Japanese.

```vim
# translate current line
:Translate

# translate specified words
:Translate hello my name is gorilla

# toggle between resource and target to translate when using "!"
:Translate!

# translate selected lines
:'<,'>Translate
```

You can set translate source, target and translate result window size.
```vim
let g:translate_source = "en"
let g:translate_target = "ja"
let g:translate_winsize = 10
```
