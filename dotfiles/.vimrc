let mapleader = " "

set backspace=indent,eol,start

syntax on
set termguicolors

set shiftwidth=4
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent

set nowrap
set nobackup
set noswapfile

set inccommand=nosplit
set incsearch
set nohlsearch
set ignorecase
set smartcase

set wildmenu

set relativenumber
set number

set signcolumn=auto

set mouse=a

set cursorline

set langmenu=en_US

let $LANG = 'en_US.UTF8'

colo habamax

source ~/.keymap.vim

command! -nargs=1 Rename execute $'saveas {expand('%:p:h')}/{"<args>"}' | call delete(expand('#'))
autocmd BufReadPost * silent! normal! g`"zvzz
autocmd VimResized * wincmd =

if has('nvim')
    au! TextYankPost * lua vim.hl.on_yank { timeout = 300 }
endif
