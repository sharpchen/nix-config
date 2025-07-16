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
xnoremap <leader>r <Esc>:'<,'>s/\%V//g<Left><Left><Left>
xnoremap <leader>R <Esc>:'<,'>s/^\%V//g<Left><Left><Left>
xnoremap <leader>: "zy:<C-r>z

nnoremap J mzJ`z

" -- jump half page up/down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" -- keep occurrence center when jumping between search results
nnoremap <silent> n :keepjumps normal! nzzzv<CR>
nnoremap <silent> N :keepjumps normal! Nzzzv<CR>

" paste last yank
nnoremap <leader>p "0p
nnoremap <leader>P "0P

nnoremap Y y$
" -- copy to system clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+y$

" -- delete to void
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap <leader>D "_D

nnoremap <silent> <leader>a :keepjumps normal! ggVG<CR>
nnoremap <silent> <A-c> :bd<CR>
nnoremap <silent> <A-,> :bp<CR>
nnoremap <silent> <A-.> :bn<CR>
nnoremap <silent> <A-a> :bufdo bd<CR>
nnoremap gh ^
nnoremap gl $
xnoremap gh ^
xnoremap gl $
nnoremap <silent> <leader>so :source ~/.vimrc<CR>
nmap <leader><leader> diw
nnoremap <leader>z I(<Esc>A)<Esc>
nnoremap <leader>Z i(<Esc>A)<Esc>
nnoremap <leader>; mzA;<Esc>`z
nnoremap <leader>, mzA,<Esc>`z
nnoremap gi gi<Esc>zzi

nnoremap <silent> <Tab> :keepjumps normal! %<CR>
xnoremap <expr> <Tab> mode()==#'V' ? '$%' : '%'
xnoremap / <C-\><C-n>`</\%V
xnoremap ? <C-\><C-n>`>?\%V
" yank uri under cursor
nnoremap <silent> yx :let @0 = expand('<cfile>')<CR>
nnoremap <silent> <leader>yx :let @+ = expand('<cfile>')<CR>
nnoremap <silent> <leader>yf :let @+ = expand('%:p')<CR>
nnoremap g[ <C-o>
nnoremap g] <C-i>
nnoremap x "_x
nnoremap <silent> <M-[> :tabp<CR>
nnoremap <silent> <M-]> :tabn<CR>
nnoremap <M-u> viwU
nnoremap <M-l> viwu

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-c> <C-w>q
