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
set statusline=%t       "tail of the filename
set statusline+=[%{&ff}] "file format
set statusline+=%m      "modified flag
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

set cmdheight=2
set updatetime=300
set signcolumn=yes

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
let g:ackprg = 'ag --nogroup --nocolor --column'

nnoremap <leader>. :Tags<cr>
nnoremap <leader>p :Files<cr>
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>f :buffers<CR>:buffer<Space>
nnoremap <leader>w <c-w><c-w>
"nnoremap <tab> <c-w><c-w>
nnoremap <leader>r :!setup_tags<cr>:cs reset<cr>
nnoremap <leader>z :silent :let @/ = '\<'.escape(expand('<cword>'), '\').'\>'<cr>:silent :set hlsearch<cr>
"nnoremap <silent> <leader>fm :call LanguageClient_contextMenu()<CR>
"nnoremap <silent> <leader>fr :call LanguageClient_textDocument_references()<CR>
"nnoremap <silent> <leader>fd :call LanguageClient_textDocument_definition()<CR>
"nnoremap <silent> <leader>fh :call LanguageClient_textDocument_hover()<CR>
"nnoremap <silent> <leader>fs :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" paste selected text to search by /
vnoremap // y/<C-R>"<CR>

"coc
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gl :CocList symbols<cr>
nmap <leader> qf  <Plug>(coc-fix-current)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

command! -nargs=0 Format :call CocAction('format')

" use cscope databases with ctags
set cst

set t_Co=256
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
au FileType xml,sgml,html set tabstop=4 shiftwidth=4 expandtab
au FileType python set tabstop=4 shiftwidth=4 expandtab
" au FileType javascript set tabstop=4 shiftwidth=4 expandtab
" au FileType html set tabstop=4 shiftwidth=4 expandtab
au FileType yaml set tabstop=4 shiftwidth=4 expandtab
au FileType json set tabstop=4 shiftwidth=4 expandtab

"let g:LanguageClient_serverCommands = {
"    \ 'go': ['go-langserver'],
"	\ 'cpp': ['cquery', '--log-file=/tmp/cq_cpp.log'],
"    \ }
"" \ 'c': ['cquery', '--log-file=/tmp/cq_c.log'],
"let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
"let g:LanguageClient_settingsPath = '/home/ildus/Dropbox/conf/lsm.json'

"set completefunc=LanguageClient#complete
"set formatexpr=LanguageClient_textDocument_rangeFormatting()

let g:rtagsUseLocationList = 0

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ressu/vim-xdg-cache'
Plug 'fatih/vim-go'
Plug 'ludovicchabant/vim-gutentags'
Plug 'plasticboy/vim-markdown'
Plug 'ntpeters/vim-better-whitespace'
Plug 'exclipy/clang_complete'
Plug 'mileszs/ack.vim'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
call plug#end()

let g:cscope_ignored_dir = 'build$\|results$'
