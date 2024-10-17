vnoremap <silent> <M-j> :m '>+1<CR>gv=gv, { silent = true })
vnoremap <silent> <M-k> :m '<-2<CR>gv=gv, { silent = true })
vnoremap <silent> <M-Down> :m '>+1<CR>gv=gv, { silent = true })
vnoremap <silent> <M-Up> :m '<-2<CR>gv=gv, { silent = true })

 " move current line up/down
nnoremap <silent> <M-j> :m .+1<CR>==
nnoremap <silent> <M-k> :m .-2<CR>==
nnoremap <silent> <M-Down> :m .+1<CR>==
nnoremap <silent> <M-Up> :m .-2<CR>==

inoremap <silent> <M-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <M-k> <Esc>:m .-2<CR>==gi
inoremap <silent> <M-Down> <Esc>:m .+1<CR>==gi
inoremap <silent> <M-Up> <Esc>:m .-2<CR>==gi

