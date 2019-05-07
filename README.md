# translate.vim
This is language translate plugin.

# Requirement
- [gtran](https://github.com/skanehira/gtran)

# Installtion
- dein.vim

```toml
[[plugins]]
repo = 'skanehira/translate.vim'
```

# Usage
Default translate english to japanese.

```vim
# translate specified words
:Translate hello my name is gorilla

# translate selected text
:'<,'>TranslateSelected
```

You can set translate source and target.
```vim
let g:translate_source = "en"
let g:translate_target = "ja"
```
