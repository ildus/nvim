"set cursorline
"set cursorcolumn
syntax on
filetype on
filetype plugin on
" filetype indent on

set ttimeoutlen=0
set hlsearch
set nowrap
set nomodeline
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set colorcolumn=80
set modeline
set showcmd
set autoindent
set scrolloff=8
set scroll=0
set number
set hidden
set iminsert=0
set imsearch=0
set showbreak=>
set linebreak textwidth=0
set fileencodings=utf-8,cp1251,koi8-r
set nojoinspaces " prevent double space when joining lines ending with '.'
set nostartofline " prevent jumping to the start of line on pgdn or pgup
set clipboard=unnamedplus

set laststatus=2
set statusline=%F       "tail of the filename
set statusline+=[%{&ff}] "file format
set statusline+=%m      "modified flag
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

set cmdheight=2
set updatetime=300
set signcolumn=yes

" set list
set listchars=tab:\ \ ┊,trail:·

set rnu
set backspace=indent,eol,start

let cache_dir = '$HOME/.cache/vim'
silent call system('mkdir ' . cache_dir)

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
	let undo_dir = cache_dir.'/undo'
	" Create dirs
	silent call system('mkdir ' . undo_dir)
	let &undodir = undo_dir
	set undofile
endif

" autoinstall everything from ~/.vim/bundle
execute pathogen#infect()
set rtp+=~/.fzf
let $FZF_DEFAULT_COMMAND = 'fd --type f --full-path'
let g:ackprg = 'fd --type f'

map <Enter> <Leader>

nnoremap <leader>z :silent :let @/ = '\<'.escape(expand('<cword>'), '\').'\>'<cr>:silent :set hlsearch<cr>

" paste selected text to search by /
vnoremap // y/<C-R>"<CR>

set t_Co=256
set background=dark
colorscheme wombat256

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

function! MakeGdbBreak()
	let path = "break ".expand('%').":".line(".")
	call writefile([path], "/tmp/gdb_breaks")
	echo "Created ".path
endfunction
function! ClearGdbBreaks()
	call writefile([""], "/tmp/gdb_breaks")
	echo "Breakpoints has been cleared"
endfunction
command! -bar GDBreak call MakeGdbBreak()
command! -bar GDBreakClear call ClearGdbBreaks()

"postgresql out files
au BufRead,BufNewFile *.out setfiletype pgout
let g:better_whitespace_filetypes_blacklist=['pgout']
let g:vim_markdown_folding_disabled = 1

au FileType xml,sgml,html set tabstop=4 shiftwidth=4 expandtab
au FileType python set tabstop=4 shiftwidth=4 expandtab
au FileType javascript set tabstop=2 shiftwidth=2 expandtab
au FileType html set tabstop=2 shiftwidth=2 expandtab
au FileType yaml set tabstop=2 shiftwidth=2 expandtab
au FileType lua set tabstop=2 shiftwidth=2 expandtab
au FileType json set tabstop=4 shiftwidth=4 expandtab
au FileType cpp set tabstop=4 shiftwidth=4 expandtab
au FileType c set tabstop=4 shiftwidth=4 expandtab
au FileType go set tabstop=4 shiftwidth=4 expandtab
au FileType dart set tabstop=2 shiftwidth=2 expandtab
au FileType systemverilog set tabstop=2 shiftwidth=2 expandtab

au BufRead,BufNewFile *.qsc setfiletype qsc
au BufRead,BufNewFile *.sc setfiletype qsc
au BufRead,BufNewFile *.qsh setfiletype qsc
au FileType qsc set tabstop=8 shiftwidth=4 noexpandtab
au FileType qsc set syntax=c

let g:localvimrc_ask = 0
let g:nv_search_paths = ['~/notes', ]
let g:nv_create_note_key = 'ctrl-n'

lua require('plugins')
