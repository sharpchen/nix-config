vim.g.mapleader = vim.keycode('<space>')

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

vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<leader>p', '"0p', { desc = 'paste last yank' })

-- copy to system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'copy to system clipboard' })

-- deleting without overwriting last clipboard
vim.keymap.set(
  'n',
  '<leader>d',
  '"_d',
  { desc = 'deleting without overwriting clipboard' }
)
vim.keymap.set(
  'v',
  '<leader>d',
  '"_d',
  { desc = 'deleting without overwriting clipboard' }
)

-- switch to another file in the system using tmux
-- vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- replacing all occurrence of current word cursor is on by input text in command bar file-wide
vim.keymap.set(
  'n',
  '<leader>s',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'replace all occurrence of current word' }
)

vim.keymap.set(
  'x',
  '<leader>s',
  [["zy:%s/\V<C-r>z/<C-r>z/gI<Left><Left><Left>]],
  { desc = 'replace all occurrence of current selection' }
)

vim.keymap.set(
  'x',
  [[<leader>:]],
  function() return vim.bo.filetype == 'lua' and [["zy:=<C-r>z]] or [["zy:<C-r>z]] end,
  { desc = 'send selection to cmdline', noremap = true, expr = true }
)

vim.keymap.set(
  'n',
  '<leader>gq',
  [[:sil grep! <C-r><C-w> | cw<Left><Left><Left><Left><Left>]],
  { desc = 'grep and pipe to qf' }
)

vim.keymap.set(
  'x',
  '<leader>gq',
  [["zy:sil grep! <C-r>z | cw<Left><Left><Left><Left><Left>]],
  { desc = 'grep and pipe to qf' }
)

vim.keymap.set(
  'n',
  '<leader>cp',
  function() require('utils.text').case.replace_cword_case('pascal') end,
  { desc = 'convert to pascal case' }
)

vim.keymap.set(
  'n',
  '<leader>cs',
  function() require('utils.text').case.replace_cword_case('snake') end,
  { desc = 'convert to snake case' }
)

vim.keymap.set(
  'n',
  '<leader>cc',
  function() require('utils.text').case.replace_cword_case('camel') end,
  { desc = 'convert to camel case' }
)

vim.keymap.set('n', '<M-u>', 'viwU', { desc = 'convert to upper case' })

vim.keymap.set('n', '<M-l>', 'viwu', { desc = 'convert to lower case' })

-- FIXME: keepjumps not working
vim.keymap.set(
  'n',
  '<leader>a',
  ':keepjumps normal! ggVG<CR>',
  { desc = 'select all text' }
)
vim.keymap.set('n', '<leader>i', '<cmd>Inspect<CR>', { desc = 'Inspect' })
vim.keymap.set(
  'n',
  '<leader>hh',
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }) end,
  { desc = 'toggle inlay hint' }
)

vim.keymap.set('n', '<A-c>', '<cmd>bd<CR>', { desc = 'close current buffer' })
vim.keymap.set('n', '<A-,>', '<cmd>bp<CR>', { desc = 'move to previous buffer' })
vim.keymap.set('n', '<A-.>', '<cmd>bn<CR>', { desc = 'move to next buffer' })
vim.keymap.set('n', '<A-a>', '<cmd>bufdo bd<CR>', { desc = 'close all buffers' })
vim.keymap.set('n', '<leader><leader>', 'diw', { remap = true })

vim.keymap.set(
  'n',
  'gh',
  '<cmd>norm! ^<CR>',
  { noremap = true, silent = true, desc = 'go to start of line' }
)
vim.keymap.set(
  'n',
  'gl',
  '<cmd>norm! $<CR>',
  { noremap = true, silent = true, desc = 'go to end of line' }
)
vim.keymap.set('n', 'gi', 'gi<Esc>zzi', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
vim.keymap.set(
  { 'n', 'x' },
  '<Tab>',
  function() return vim.fn.mode() == 'V' and '$%' or '%' end,
  { noremap = true, expr = true }
)
vim.keymap.set(
  'n',
  '<leader>z',
  'I(<Esc>A)',
  { noremap = true, desc = 'brace line with ()' }
)
vim.keymap.set(
  'n',
  '<leader>;',
  'mzA;<Esc>`z',
  { noremap = true, desc = 'append ; at the end of line' }
)
vim.keymap.set(
  'n',
  '<leader>,',
  'mzA,<Esc>`z',
  { noremap = true, desc = 'append ; at the end of line' }
)

vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = 'go to window downward' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = 'go to window upward' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = 'go to window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = 'go to window right' })
vim.keymap.set('n', '<C-c>', '<C-w>q', { noremap = true, desc = 'close current window' })

if IsLinux then
  vim.keymap.set(
    'n',
    '<leader>x',
    '<cmd>!chmod +x %<CR>',
    { silent = true, desc = 'make current file executable' }
  )
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true, nowait = true }
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

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'qf',
--   callback = function(event)
--     local opts = { buffer = event.buf, silent = true }
--     local init_bufnr = vim.fn.bufnr('#')
--     vim.keymap.set('n', '<C-n>', function() mv_qf_item(true, init_bufnr) end, opts)
--     vim.keymap.set('n', '<C-p>', function() mv_qf_item(false, init_bufnr) end, opts)
--     vim.keymap.set('n', '<C-j>', function() mv_qf_item(true, init_bufnr) end, opts)
--     vim.keymap.set('n', '<C-k>', function() mv_qf_item(false, init_bufnr) end, opts)
--   end,
-- })

function _G.select_md_code_block(around)
  local cur_line = vim.fn.line('.')
  local start, finish = nil, nil

  -- Find the start ```
  for i = cur_line, 1, -1 do
    if vim.trim(vim.fn.getline(i)):match('%s+^```') then
      start = i
      break
    end
  end

  -- Find the end ```
  for i = cur_line, vim.fn.line('$') do
    if vim.trim(vim.fn.getline(i)):match('%s+^```') then
      finish = i
      break
    end
  end

  -- Ensure valid range
  if not start or not finish or start == finish then return end

  if around then
    -- Select around (including ``` lines)
    vim.cmd(string.format('normal! %dGV%dG', start, finish))
  else
    -- Select inside (excluding ``` lines)
    vim.cmd(string.format('normal! %dGV%dG', start + 1, finish - 1))
  end
end

-- Map "vi`" to select inside a Markdown code block
vim.keymap.set(
  'o',
  'im',
  '<cmd>lua select_md_code_block(false)<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  'x',
  'im',
  '<cmd>lua select_md_code_block(false)<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  'o',
  'am',
  '<cmd>lua select_md_code_block(true)<CR>',
  { noremap = true, silent = true }
)
vim.keymap.set(
  'x',
  'am',
  '<cmd>lua select_md_code_block(true)<CR>',
  { noremap = true, silent = true }
)

vim.keymap.set('n', '<leader>ll', function()
  if not _G.__diag_config then _G.__diag_config = vim.diagnostic.config() or {} end
  local current_config = vim.diagnostic.config() or {}
  if current_config.virtual_text then
    vim.diagnostic.config {
      virtual_text = false,
      virtual_lines = {
        current_line = true,
        format = _G.__diag_fmt,
      },
    }
  else
    vim.diagnostic.config(_G.__diag_config)
  end
end, { desc = 'Toggle lsp_lines' })

vim.keymap.set(
  'n',
  '<leader>ls',
  function() vim.o.list = not vim.o.list end,
  { desc = 'Toggle list char' }
)
