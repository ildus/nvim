My `neovim` configuration
---------------------

Hotkeys
=========

Leader key - '\\'

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
	git clone git@github.com:ildus/nvim.git ~/.config/nvim
```

2) Start neovim
3) Run `:PlugInstall`
4) Install `the_platinum_searcher`
