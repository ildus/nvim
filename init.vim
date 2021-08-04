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
let $FZF_DEFAULT_COMMAND = 'pt --ignore="contrib/" -l -g ""'
let g:ackprg = 'pt --nogroup --nocolor --column --ignore="./contrib"'

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
" nmap <leader> qf  <Plug>(coc-fix-current)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

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
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'html', 'c', 'cpp'] }
let g:syntastic_disabled_filetypes=['html', 'cpp', 'c']
let g:syntastic_python_flake8_post_args='--ignore=E501,E128,E225,W191'

let g:vim_markdown_folding_disabled = 1

" au FileType c setl formatprg=$HOME/src/indent/indent\ -bc\ -bl\ -nce
au FileType xml,sgml,html set tabstop=4 shiftwidth=4 expandtab
au FileType python set tabstop=4 shiftwidth=4 expandtab
" au FileType javascript set tabstop=4 shiftwidth=4 expandtab
" au FileType html set tabstop=4 shiftwidth=4 expandtab
au FileType yaml set tabstop=2 shiftwidth=2 expandtab
au FileType json set tabstop=4 shiftwidth=4 expandtab
au FileType cpp set tabstop=4 shiftwidth=4 expandtab

let g:rtagsUseLocationList = 0

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ressu/vim-xdg-cache'
"Plug 'fatih/vim-go'
Plug 'ludovicchabant/vim-gutentags'
Plug 'plasticboy/vim-markdown'
Plug 'ntpeters/vim-better-whitespace'
Plug 'exclipy/clang_complete'
Plug 'mileszs/ack.vim'
Plug 'neovim/nvim-lspconfig'
call plug#end()

let g:cscope_ignored_dir = 'build$\|results$'

au FileType go set tabstop=4 shiftwidth=4 noexpandtab

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "clangd", "gopls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
