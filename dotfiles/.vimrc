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

set incsearch
set ignorecase
set smartcase

set wildmenu

set relativenumber
set number

set signcolumn=auto

set mouse=a

set cursorline

set langmenu=en_US

let $LANG = 'en_US'

colo habamax
" Move selected lines down/up in visual mode
xnoremap <silent> <M-j> :m '>+1<CR>gv=gv
xnoremap <silent> <M-k> :m '<-2<CR>gv=gv
xnoremap <silent> <M-Down> :m '>+1<CR>gv=gv
xnoremap <silent> <M-Up> :m '<-2<CR>gv=gv

" Move current line down/up in normal mode
nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==
nnoremap <silent> <M-Down> :m .+1<CR>==
nnoremap <silent> <M-Up> :m .-2<CR>==

" Move current line down/up in insert mode
inoremap <silent> <M-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <M-k> <Esc>:m .-2<CR>==gi
inoremap <silent> <M-Down> <Esc>:m .+1<CR>==gi
inoremap <silent> <M-Up> <Esc>:m .-2<CR>==gi

nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>


nnoremap J mzJ`z

" -- jump half page up/down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" -- keep occurrence center when jumping between search results
nnoremap n nzzzv
nnoremap N Nzzzv

" -- avoid replacing selected text overwrites previous copy
xnoremap <leader>p "_dP

" -- copy to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" -- deleting without overwriting last clipboard
nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap <leader>a ggVG
nnoremap <A-c> :bd<CR>
nnoremap <A-,> :bp<CR>
nnoremap <A-.> :bn<CR>
nnoremap <A-a> :bufdo bd<CR>
nnoremap 0 ^
nnoremap ^ 0
nnoremap <silent> gh :norm! 0<CR>
nnoremap <silent> gl :norm! $<CR>