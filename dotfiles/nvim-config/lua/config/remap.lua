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

-- keep occurrence center when jumping between search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<leader>p', '"0p', { desc = 'paste last yank' })

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

vim.keymap.set('n', '<M-u>', function()
  local sub = vim.fn.expand('<cword>'):upper()
  vim.cmd(string.format("execute 'norm! viw' | execute 'norm! c%s'", sub))
end)

vim.keymap.set('n', '<M-l>', function()
  local sub = vim.fn.expand('<cword>'):lower()
  vim.cmd(string.format("execute 'norm! viw' | execute 'norm! c%s'", sub))
end)

vim.keymap.set('n', '<leader>a', 'ggVG', { desc = 'select all text' })
vim.keymap.set('n', '<leader>i', '<cmd>Inspect<CR>', { desc = 'Inspect' })
vim.keymap.set('n', '<leader>hh', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = 'toggle inlay hint' })

vim.keymap.set('n', '<A-c>', '<cmd>bd<CR>', { desc = 'close current buffer' })
vim.keymap.set('n', '<A-,>', '<cmd>bp<CR>', { desc = 'move to previous buffer' })
vim.keymap.set('n', '<A-.>', '<cmd>bn<CR>', { desc = 'move to next buffer' })
vim.keymap.set('n', '<A-a>', '<cmd>bufdo bd<CR>', { desc = 'close all buffers' })
vim.keymap.set('n', '<leader><leader>', 'diw')

-- vim.keymap.set('n', '0', '^', { noremap = true, silent = true, desc = 'go to start of line' })
-- vim.keymap.set('n', '^', '0', { noremap = true, silent = true, desc = 'go to first word bound of line' })
vim.keymap.set('n', 'gh', '<cmd>norm! ^<CR>', { noremap = true, silent = true, desc = 'go to start of line' })
vim.keymap.set('n', 'gl', '<cmd>norm! $<CR>', { noremap = true, silent = true, desc = 'go to end of line' })
vim.keymap.set('n', 'gi', 'gi<Esc>zzi', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
vim.keymap.set('n', '<leader>z', 'I(<Esc>A)', { noremap = true, desc = 'brace line with ()' })
vim.keymap.set('n', '<leader>;', 'mzA;<Esc>`z', { noremap = true, desc = 'append ; at the end of line' })
vim.keymap.set('n', '<leader>,', 'mzA,<Esc>`z', { noremap = true, desc = 'append ; at the end of line' })

vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = 'go to window downward' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = 'go to window upward' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = 'go to window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = 'go to window right' })
vim.keymap.set('n', '<C-q>', '<C-w>q', { noremap = true, desc = 'close current window' })

vim.iter({ { '(', ')' }, { '<', '>' }, { '[', ']' }, '`', '"', "'", '*' }):each(function(x)
  if type(x) == 'table' then
    vim.keymap.set(
      'n',
      ('[%s'):format(x[1]),
      ('viw<esc>a%s<esc>bi%s<esc>'):format(x[2], x[1]),
      { desc = ('surround word with %s%s'):format(x[1], x[2]) }
    )
  else
    vim.keymap.set(
      'n',
      ('[%s'):format(x),
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

---@param next boolean
local function mv_qf_item(next, init_bufnr)
  local is_top = vim.fn.line('.') == 1
  local is_bottom = vim.fn.line('.') == vim.fn.line('$')

  local is_not_init_buf = false
  -- go back to file so we can delete the buf
  if vim.bo.filetype == 'qf' then
    vim.cmd('wincmd p')
    is_not_init_buf = vim.fn.bufnr('%') ~= init_bufnr
  end

  if is_not_init_buf then
    -- delete and go back to qf
    vim.cmd('bd | copen')
  end

  if is_top and not next then
    vim.cmd('clast')
  elseif is_bottom and next then
    vim.cmd('cfirst')
  else
    vim.cmd(next and 'cn' or 'cN')
  end

  -- center location
  vim.api.nvim_feedkeys('zz', 't', false)

  -- resize qf(should stay in file)
  vim.cmd(
    string.format(
      'res %s',
      math.floor(
        (vim.o.lines - vim.o.cmdheight - (vim.o.laststatus == 0 and 0 or 1) - (vim.o.tabline == '' and 0 or 1)) / 3 * 2
          + 0.5
      ) + 3
    )
  )

  -- make sure go back to qf
  if vim.bo.filetype ~= 'qf' then
    vim.cmd('copen')
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local init_bufnr = vim.fn.bufnr('#')
    vim.keymap.set('n', '<C-n>', function()
      mv_qf_item(true, init_bufnr)
    end, opts)

    vim.keymap.set('n', '<C-p>', function()
      mv_qf_item(false, init_bufnr)
    end, opts)

    vim.keymap.set('n', '<C-j>', function()
      mv_qf_item(true, init_bufnr)
    end, opts)

    vim.keymap.set('n', '<C-k>', function()
      mv_qf_item(false, init_bufnr)
    end, opts)
  end,
})

function _G.select_md_code_block()
  local start, finish = nil, nil

  for i = vim.fn.line('.') - 1, 1, -1 do
    if vim.trim(vim.fn.getline(i)):match('^```') then
      start = i
      break
    end
  end

  for i = vim.fn.line('.') + 1, vim.fn.line('$') do
    if vim.trim(vim.fn.getline(i)):match('^```') then
      finish = i
      break
    end
  end

  if start and finish and start ~= finish then
    vim.cmd(string.format('normal! %dGV%dG', start + 1, finish - 1)) -- Select content
  end
end

-- Map "vi`" to select inside a Markdown code block
vim.keymap.set('o', 'im', ':lua select_md_code_block()<CR>', { noremap = true, silent = true })
vim.keymap.set('x', 'im', ':lua select_md_code_block()<CR>', { noremap = true, silent = true })
vim.keymap.set('o', 'am', ':lua select_md_code_block()<CR>', { noremap = true, silent = true })
vim.keymap.set('x', 'am', ':lua select_md_code_block()<CR>', { noremap = true, silent = true })
