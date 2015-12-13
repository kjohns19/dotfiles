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
call vundle#end()
filetype plugin on

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_check_header = 1

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

" command history
set history=500

let mapleader="\<C-k>"

" different color past 100 characters
let &colorcolumn=join(range(100, 500),",")

syn on

" colorscheme setup
let g:jellybeans_overrides = {
\    'ColorColumn': { 'guibg': '242424', 'ctermbg': 234 },
\    'Search':      { 'guifg': 'f0a0c0', 'ctermfg': 'Magenta', 'gui': 'underline' },
\    'Special':     { 'guifg': '397d3a', 'ctermfg': 'Green' }
\}
colorscheme jellybeans

set omnifunc=syntaxcomplete#Complete

" move up and down visible columns (helps with line wrapping)
nnoremap j gj
nnoremap k gk

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

nnoremap <Leader>s :Ack! <cword><CR>
nnoremap <Leader>S :Ack! --type-add hh:ext:hpp --hh <cword><CR>
nnoremap <Leader>a :Ack! 
nnoremap <Leader>A :Ack! --type-add hh:ext:hpp --hh 

" reload vimrc
nmap <Leader>r :so ~/.vimrc<CR>

" simple gui
set guioptions-=m        " remove menu bar
set guioptions-=T        " remove toolbar
set guioptions-=r        " remove right scroll bar
set guioptions-=L        " remove left scroll bar
set guioptions-=e        " remove gui tabs
set guicursor=a:blinkon0 " disable blinking
