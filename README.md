My vim configuration
---------------------

Plugins
==================

```
'junegunn/fzf',
'junegunn/fzf.vim'
'ressu/vim-xdg-cache'
'fatih/vim-go'
'ludovicchabant/vim-gutentags'
'plasticboy/vim-markdown'
'ntpeters/vim-better-whitespace'
'exclipy/clang_complete'
'mileszs/ack.vim'
'vim-syntastic/syntastic'
```

Hotkeys
=========

Leader key - '\'

* `<leader>w` - switch between windows
* `<leader>p` - open file from current folder (fuzzy search)
* `<leader>.` - search tag (fuzzy search)
* `<leader>v` - vertical split
* `<leader>f` - fast buffer selection
* `<leader>z` - search and visual text selection without moving to next match
* `//` - in visual mode, search by selected text

Cscope

* `<leader>c` - show calls
* `<leader>s` - show symbols
* `<leader>g` - show definition

Installation steps
===================

1) Clone to your home folder:

```
	git clone git@github.com:ildus/.vim.git ~/.vim
```

2) Start vim
3) Run `:PlugInstall`
