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
xnoremap <leader>s "zy:%s/\V<C-r>z/<C-r>z/gI<Left><Left><Left>
nnoremap <leader>S :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
xnoremap <leader>S "zy:%s/\V<C-r>z//gI<Left><Left><Left>
xnoremap <leader>r <C-\><C-n>`>:%s/\%V//g<Left><Left><Left>
xnoremap <leader>r <C-\><C-n>`>:%s/^\%V//g<Left><Left><Left>
xnoremap <leader>: "zy:<C-r>z

nnoremap J mzJ`z

" -- jump half page up/down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" -- keep occurrence center when jumping between search results
nnoremap n :keepjumps normal! nzzzv<CR>
nnoremap N :keepjumps normal! Nzzzv<CR>


" paste last yank
nnoremap <leader>p "0p
nnoremap <leader>P "0P

" -- copy to system clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" -- delete to void
nnoremap <leader>d "_d
xnoremap <leader>d "_d

" FIXME: keepjumps not working
nnoremap <leader>a :keepjumps normal! ggVG<CR>
nnoremap <silent> <A-c> :bd<CR>
nnoremap <silent> <A-,> :bp<CR>
nnoremap <silent> <A-.> :bn<CR>
nnoremap <silent> <A-a> :bufdo bd<CR>
nnoremap <silent> gh ^
nnoremap <silent> gl $
nnoremap <silent> <leader>so :source ~/.vimrc<CR>
nnoremap <leader><leader> diw
nnoremap <leader>z I(<Esc>A)
nnoremap <leader>; mzA;<Esc>`z
nnoremap <leader>, mzA,<Esc>`z
nnoremap gi gi<Esc>zzi

au BufReadPost * silent! normal! g`"zvzz
au FileType *.markdown nnoremap <silent> <buffer> <C-b> mz:s/\<<C-r><C-w>\>/**<C-r><C-w>**/<CR>`z
au FileType *.markdown vnoremap <silent> <buffer> <C-b> mz"zy:s/\<<C-r>z\>/**<C-r>z**/<CR>`z

nnoremap <Tab> :keepjumps normal! %<CR>
xnoremap <expr> <Tab> mode()==#'V' ? ':keepjumps normal! $%<CR>' : ':keepjumps normal! %<CR>'
xnoremap / <C-\><C-n>`</\%V
xnoremap ? <C-\><C-n>`>?\%V
" yank uri under cursor
nnoremap yx :let @0 = expand('<cfile>')<CR>
nnoremap <leader>yx :let @+ = expand('<cfile>')<CR>
