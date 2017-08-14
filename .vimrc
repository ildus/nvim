"set cursorline
"set cursorcolumn
syntax on
filetype on
filetype plugin on
" filetype indent on

set ttimeoutlen=0
set hlsearch
set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set colorcolumn=80
set modeline
set showcmd
set autoindent
set scrolloff=8
set number
set iminsert=0
set imsearch=0
set showbreak=>
set linebreak textwidth=0
set fileencodings=utf-8,cp1251,koi8-r
set nojoinspaces " prevent double space when joining lines ending with '.'
set nostartofline " prevent jumping to the start of line on pgdn or pgup

set laststatus=2
set statusline=%t       "tail of the filename
set statusline+=[%{&ff}] "file format
set statusline+=%m      "modified flag
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

"set listchars=tab:>·,trail:~
"set listchars=trail:~
" set list

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
let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

nnoremap <leader>. :Tags<cr>
nnoremap <leader>p :Files<cr>
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>f :buffers<CR>:buffer<Space>
nnoremap <leader>w <c-w><c-w>
nnoremap <leader>r :!setup_tags<cr>:cs reset<cr>:cs add cscope.out

" use cscope databases with ctags
set cst

set t_Co=256
"colorscheme PaperColor
set background=dark
colorscheme wombat256

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

nnoremap <leader>b :GDBreak<cr>
nnoremap <leader>x :GDBreakClear<cr>

"postgresql out files
au BufRead,BufNewFile *.out setfiletype pgout
let g:better_whitespace_filetypes_blacklist=['pgout']

"include files
let g:syntastic_c_compiler='clang'
let g:syntastic_c_compiler_options='-std=c89'
let g:syntastic_c_include_dirs=['/home/ildus/pgpro/include/postgresql/server']
let g:syntastic_c_no_default_include_dirs=1
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'html'] }
let g:syntastic_disabled_filetypes=['html']
let g:syntastic_python_flake8_post_args='--ignore=E501,E128,E225,W191'

" au FileType c setl formatprg=$HOME/src/indent/indent\ -bc\ -bl\ -nce
au FileType xml,html,sgml source $HOME/.vim/scripts/xmlwrap.vim
au FileType sgml set tabstop=4 shiftwidth=4 expandtab
au FileType python set tabstop=4 shiftwidth=4 noexpandtab
" au FileType javascript set tabstop=4 shiftwidth=4 expandtab
" au FileType html set tabstop=4 shiftwidth=4 expandtab
au FileType yaml set tabstop=4 shiftwidth=4 expandtab
au FileType json set tabstop=4 shiftwidth=4 expandtab

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ressu/vim-xdg-cache'
Plug 'fatih/vim-go'
Plug 'ludovicchabant/vim-gutentags'
Plug 'plasticboy/vim-markdown'
Plug 'vim-syntastic/syntastic'
Plug 'ntpeters/vim-better-whitespace'
Plug 'exclipy/clang_complete'
call plug#end()
