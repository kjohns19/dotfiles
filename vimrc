version 6.0

" not compatible with vi
set nocompatible

" Plugins
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nanotech/jellybeans.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'nvie/vim-flake8'
Plugin 'tikhomirov/vim-glsl'
call vundle#end()
filetype plugin on

" syntastic settings
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["c", "cpp"]}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_config_file = '.syntastic_cpp_config'
let g:syntastic_cpp_check_header = 0
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++20 -Wall '
    \. substitute(system('pkg-config --cflags-only-I gtkmm-3.0'), "\n", ' ', '')
    \. substitute(system('/usr/bin/python3.8-config --includes'), "\n", '', '')
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = '-std=gnu17 -Wall'
let g:syntastic_c_config_file = '.syntastic_c_config'
let g:syntastic_loc_list_height = 5
let g:syntastic_python_python_exec = '/usr/bin/python3.12'

" flake8 settings
let g:flake8_show_in_gutter=1
" Same flake8 command as the bash alias
let g:flake8_cmd=$HOME .. '/bin/run-venv flake8 --config ' .. $HOME .. '/.flake8'

" 256 colors
set t_Co=256

" fast terminal connection
set ttyfast

" line numbers and cursor position
set number
set ruler

" tabs are 4 spaces, round < and > shifting
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround

" can use mouse
set mouse=a
" can backspace over anything
set backspace=2

" create folds based on indent, start all open
set foldmethod=indent
set foldlevelstart=99

" unicode
set encoding=utf-8
set termencoding=utf-8

" use last indent on next line
set autoindent

" highlight current line
set cursorline

" highlight search results
set hlsearch

set updatetime=250

" command history
set history=500

" allow more tabs to open when using vim -p ___
set tabpagemax=100

let mapleader="\<C-k>"

" different color past 100 characters
let &colorcolumn=join(range(100, 500),",")

highlight UnwantedWS guibg=red
match UnwantedWS /\s\+$\|\t/
au WinEnter * match UnwantedWS /\s\+$\|\t/

syn on

" colorscheme setup
let g:jellybeans_overrides = {
\    'ColorColumn':     { 'guibg': '242424' },
\    'UnwantedWS':      { 'guibg': '2c2c2c' },
\    'Search':          { 'guifg': 'f0a0c0', 'gui': 'underline' },
\    'GitGutterDelete': { 'guifg': 'f00000' },
\    'Special':         { 'guifg': '397d3a' }
\}

let g:gitgutter_set_sign_backgrounds = 1  " Match the gutter background color

colorscheme jellybeans

set omnifunc=syntaxcomplete#Complete

" move up and down visible columns (helps with line wrapping)
nnoremap j gj
nnoremap k gk
nnoremap gk k
nnoremap gj j

nnoremap <Leader>i K
nnoremap K <nop>

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" search for entire words (i.e. 'foo' will find 'foo' but not 'foobar' or 'barfoo')
nnoremap <Leader>v /\<\><left><left>
" and reverse search
nnoremap <Leader>V ?\<\><left><left>

" search for function calls and definitions (all - cannot specify function)
nnoremap <Leader>f /\(\(if\\|for\\|while\\|switch\\|sizeof\\|return\)\_s*(\)\@!\<\h\w*\(\_s*(\)\@=<CR>
" and reverse search
nnoremap <Leader>F ?\(\(if\\|for\\|while\\|switch\\|sizeof\\|return\)\_s*(\)\@!\<\h\w*\(\_s*(\)\@=<CR>

" move tab left or right
nnoremap <Leader><C-h> :tabm-1<CR>
nnoremap <Leader><C-l> :tabm+1<CR>

" cd to file directory (local and global)
nnoremap <Leader>c :lcd %:p:h<CR>
nnoremap <Leader>C :cd %:p:h<CR>

" search with ack
nnoremap <Leader>s :Ack! "\b<cword>\b"<CR>
nnoremap <Leader>S :Ack! --type-add hh:ext:hpp --hh "\b<cword>\b"<CR>
nnoremap <Leader>a :Ack! "\b\b"<left><left><left>
nnoremap <Leader>A :Ack! --type-add hh:ext:hpp --hh "\b\b"<left><left><left>

" Formatter (see ftplugin/<filetype>.vim for the per-filetype functions)
" Default functions that do nothing (no formatter for the current filetype)
function s:FileFormatFuncDefault()
    " do nothing
endfunction
function s:FileFormatRangeFuncDefault() range
    " do nothing
endfunction
autocmd BufRead,BufNewFile *
    \ if !exists('b:FileFormatFunc') |
    \   let b:FileFormatFunc = function('<SID>FileFormatFuncDefault') |
    \ endif
autocmd BufRead,BufNewFile *
    \ if !exists('b:FileFormatRangeFunc') |
    \   let b:FileFormatRangeFunc = function('<SID>FileFormatRangeFuncDefault') |
    \ endif

" In normal mode, format the whole file. In visual mode, format the selection
nnoremap <Leader>o :call b:FileFormatFunc()<CR>
vnoremap <Leader>o :call b:FileFormatRangeFunc()<CR>

" next/previous change
nmap <Leader><C-j> <Plug>(GitGutterNextHunk)
nmap <Leader><C-k> <Plug>(GitGutterPrevHunk)

" reload vimrc
nmap <Leader>r :so ~/.vimrc<CR>

" store swapfiles here (// will make it use the complete path in the name for uniqueness)
set directory=$HOME/.vim/swapfiles//

" simple gui
set guioptions-=m        " remove menu bar
set guioptions-=T        " remove toolbar
set guioptions-=r        " remove right scroll bar
set guioptions-=L        " remove left scroll bar
set guioptions-=e        " remove gui tabs
set guicursor=a:blinkon0 " disable blinking
