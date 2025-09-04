"set cursorline
"set cursorcolumn
syntax on
filetype on
filetype plugin on
" filetype indent on

set hlsearch
set nowrap
set nomodeline
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set colorcolumn=90
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
set clipboard+=unnamedplus

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

map <Enter> <Leader>
nnoremap <leader>z :silent :let @/ = '\<'.escape(expand('<cword>'), '\').'\>'<cr>:silent :set hlsearch<cr>

" paste selected text to search by /
vnoremap // y/<C-R>"<CR>

if (empty($SCREEN_LIST))
  set termguicolors
endif

set background=dark
colorscheme wombat

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

" setup notational vim
let notes_dir = "~/Sync/notes"
silent call system('mkdir -p ' . notes_dir)

" setup localvimrc plugin
let g:localvimrc_ask = 0

" command for gutentags
let g:gutentags_file_list_command = 'rg --files'

" set up plugins
lua require('init_lazy')

let g:notes_path = [notes_dir, ]
silent! command -nargs=* -bang Notes lua require('notes').search_notes()
" silent! command -nargs=* -bang NotesTel lua require('notes_telescope').search_notes()

:autocmd BufWritePre [:;\\]*
\   try | echoerr 'Forbidden file name: '..expand('<afile>') | endtry
