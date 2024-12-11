vim.g.mapleader = ' '

-- move selected lines up/down
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<M-Down>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<M-Up>', ":m '<-2<CR>gv=gv", { silent = true })

-- move current line up/down
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('n', '<M-Down>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<M-Up>', ':m .-2<CR>==', { silent = true })

vim.keymap.set('i', '<M-j>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<M-k>', '<Esc>:m .-2<CR>==gi', { silent = true })
vim.keymap.set('i', '<M-Down>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<M-Up>', '<Esc>:m .-2<CR>==gi', { silent = true })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'join next line with still cursor' })

-- jump half page up/down
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- keep occurrence center when jumping between search results
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- avoid replacing selected text overwrites previous copy
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'pasting without overwriting copy' })

-- copy to system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'copy to system clipboard' })

-- deleting without overwriting last clipboard
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'deleting without overwriting clipboard' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'deleting without overwriting clipboard' })

-- switch to another file in the system using tmux
-- vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- replacing all occurrence of current word cursor is on by input text in command bar file-wide
vim.keymap.set(
  'n',
  '<leader>s',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'replace all occurrence of current word' }
)

vim.keymap.set('n', '<leader>cp', function()
  local sub = require('utils.text').case.convert(vim.fn.expand('<cword>'), 'pascal')
  vim.cmd(string.format("execute 'norm! viw' | execute 'norm! c%s'", sub))
end)

vim.keymap.set('n', '<leader>cs', function()
  local sub = require('utils.text').case.convert(vim.fn.expand('<cword>'), 'snake')
  vim.cmd(string.format("execute 'norm! viw' | execute 'norm! c%s'", sub))
end)

vim.keymap.set('n', '<leader>cc', function()
  local sub = require('utils.text').case.convert(vim.fn.expand('<cword>'), 'camel')
  vim.cmd(string.format("execute 'norm! viw' | execute 'norm! c%s'", sub))
end)

vim.keymap.set('n', '<leader>a', 'ggVG', { desc = 'select all text' })
vim.keymap.set('n', '<leader>i', '<cmd>Inspect<CR>', { desc = 'Inspect' })
vim.keymap.set('n', '<leader>h', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = 'toggle inlay hint' })

vim.keymap.set('n', '<A-c>', '<cmd>bd<CR>', { desc = 'close current buffer' })
vim.keymap.set('n', '<A-,>', '<cmd>bp<CR>', { desc = 'move to previous buffer' })
vim.keymap.set('n', '<A-.>', '<cmd>bn<CR>', { desc = 'move to next buffer' })
vim.keymap.set('n', '<A-a>', '<cmd>bufdo bd<CR>', { desc = 'close all buffers' })
vim.keymap.set('n', '<leader><leader>', 'diw')

vim.keymap.set('n', '0', '^', { noremap = true, silent = true, desc = 'go to start of line' })
vim.keymap.set('n', '^', '0', { noremap = true, silent = true, desc = 'go to first word bound of line' })
vim.keymap.set('n', 'gh', '<cmd>norm! 0<CR>', { noremap = true, silent = true, desc = 'go to start of line' })
vim.keymap.set('n', 'gl', '<cmd>norm! $<CR>', { noremap = true, silent = true, desc = 'go to end of line' })

vim.iter({ { '(', ')' }, { '<', '>' }, { '[', ']' }, '`', '"', "'", '*' }):each(function(x)
  if type(x) == 'table' then
    vim.keymap.set(
      'n',
      ('<leader>[%s'):format(x[1]),
      ('viw<esc>a%s<esc>bi%s<esc>'):format(x[2], x[1]),
      { desc = ('surround word with %s%s'):format(x[1], x[2]) }
    )
  else
    vim.keymap.set(
      'n',
      ('<leader>[%s'):format(x),
      ('viw<esc>a%s<esc>bi%s<esc>'):format(x, x),
      { desc = ('surround word with %s'):format(x) }
    )
  end
end)

if vim.uv.os_uname().sysname == 'Linux' then
  vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'make current file executable' })
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server
    -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    -- gi was a builtin keymap, not using go to implementation now
    -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    -- vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})
vim.keymap.set('n', '<leader>ti', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = 'toggle inlay hint' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local init_bufnr = vim.fn.bufnr('#')
    vim.keymap.set('n', '<C-n>', function()
      if vim.fn.line('.') == vim.fn.line('$') then
        vim.notify('E553: No more items', vim.log.levels.INFO)
        return
      end
      vim.cmd('wincmd p') -- jump to current displayed file
      vim.cmd(
        (vim.fn.bufnr('%') ~= init_bufnr and vim.bo.filetype ~= 'qf')
            and ('bd | wincmd p | cn | res %d'):format(
              math.floor(
                (vim.o.lines - vim.o.cmdheight - (vim.o.laststatus == 0 and 0 or 1) - (vim.o.tabline == '' and 0 or 1))
                    / 3
                    * 2
                  + 0.5
              ) - 1
            )
          or 'cn'
      )
      vim.cmd('normal! zz')
      if vim.bo.filetype ~= 'qf' then
        vim.cmd('wincmd p')
      end
    end, opts)

    vim.keymap.set('n', '<C-p>', function()
      if vim.fn.line('.') == 1 then
        vim.notify('E553: No more items', vim.log.levels.INFO)
        return
      end
      vim.cmd('wincmd p') -- jump to current displayed file
      vim.cmd(
        (vim.fn.bufnr('%') ~= init_bufnr and vim.bo.filetype ~= 'qf')
            and ('bd | wincmd p | cN | res %d'):format(
              math.floor(
                (vim.o.lines - vim.o.cmdheight - (vim.o.laststatus == 0 and 0 or 1) - (vim.o.tabline == '' and 0 or 1))
                    / 3
                    * 2
                  + 0.5
              ) - 1
            )
          or 'cN'
      )
      vim.cmd('normal! zz')
      if vim.bo.filetype ~= 'qf' then
        vim.cmd('wincmd p')
      end
    end, opts)
  end,
})
