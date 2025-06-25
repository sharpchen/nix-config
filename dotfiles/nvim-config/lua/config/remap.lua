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

vim.keymap.set('n', 'n', '<cmd>keepjumps normal! nzzzv<CR>')
vim.keymap.set('n', 'N', '<cmd>keepjumps normal! Nzzzv<CR>')

vim.keymap.set('n', '<leader>p', '"0p', { desc = 'paste last yanked' })
vim.keymap.set('n', '<leader>P', '"0P', { desc = 'paste last yanked' })

-- copy to system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('x', '<leader>y', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = 'copy to system clipboard' })

-- deleting without overwriting last clipboard
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'delete to void' })
vim.keymap.set('n', '<leader>D', '"_D', { desc = 'delete to void' })
vim.keymap.set('x', '<leader>d', '"_d', { desc = 'delete to void' })

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
  'n',
  '<leader>S',
  [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
  { desc = 'replace all occurrence of current word without pre-fill' }
)

vim.keymap.set(
  'x',
  '<leader>s',
  [["zy:%s/\V<C-r>z/<C-r>z/gI<Left><Left><Left>]],
  { desc = 'replace all occurrence of current selection' }
)

vim.keymap.set(
  'x',
  '<leader>S',
  [["zy:%s/\V<C-r>z//gI<Left><Left><Left>]],
  { desc = 'replace all occurrence of current selection without pre-fill' }
)

vim.keymap.set(
  'x',
  [[<leader>:]],
  function() return vim.bo.filetype == 'lua' and [["zy:=<C-r>z]] or [["zy:<C-r>z]] end,
  { desc = 'send selection to cmdline', expr = true }
)

vim.keymap.set(
  'x',
  '<leader>r',
  [[<C-\><C-n>`>:%s/\%V//g<Left><Left><Left>]],
  { desc = '[R]eplace in selection' }
)

vim.keymap.set(
  'x',
  '<leader>R',
  [[<C-\><C-n>`>:%s/^\%V//g<Left><Left><Left>]],
  { desc = '[R]eplace start of line in selection' }
)

vim.keymap.set(
  'n',
  '<leader>gq',
  [[:sil grep! '\b<C-r><C-w>\b' | cw<Left><Left><Left><Left><Left><Left><Left><Left>]],
  { desc = '[G]rep and pipe to [Q]f' }
)

vim.keymap.set(
  'n',
  '<leader>gQ',
  [[:sil grep!  | cw<Left><Left><Left><Left><Left>]],
  { desc = '[G]rep and pipe to [Q]f' }
)

vim.keymap.set(
  'x',
  '<leader>gq',
  [["zy:sil grep! <C-r>z | cw<Left><Left><Left><Left><Left>]],
  { desc = '[G]rep and pipe to [Q]f' }
)

vim.keymap.set('n', '<leader>cp', function()
  local cword = vim.fn.expand('<cword>')
  local new_word = require('utils.text').case.convert(cword, 'pascal')
  if cword ~= new_word then require('utils.text').replace_cword(new_word) end
end, { desc = '[C]onvert to [P]ascal case' })

vim.keymap.set('n', '<leader>cs', function()
  local cword = vim.fn.expand('<cword>')
  local new_word = require('utils.text').case.convert(cword, 'snake')
  if cword ~= new_word then require('utils.text').replace_cword(new_word) end
end, { desc = '[C]onvert to [S]nake case' })

vim.keymap.set('n', '<leader>cc', function()
  local cword = vim.fn.expand('<cword>')
  local new_word = require('utils.text').case.convert(cword, 'camel')
  if cword ~= new_word then require('utils.text').replace_cword(new_word) end
end, { desc = '[C]onvert to [C]amel case' })

vim.keymap.set('n', '<M-u>', 'viwU', { desc = 'convert to upper case' })

vim.keymap.set('n', '<M-l>', 'viwu', { desc = 'convert to lower case' })

-- FIXME: keepjumps not working
vim.keymap.set(
  'n',
  '<leader>a',
  ':keepjumps normal! ggVG<CR>',
  { desc = 'select [A]ll text' }
)
vim.keymap.set('n', '<leader>i', '<cmd>Inspect<CR>', { desc = 'Inspect' })
vim.keymap.set(
  'n',
  '<leader>hh',
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }) end,
  { desc = 'toggle inlay [H]int' }
)

vim.keymap.set('n', '<A-c>', '<cmd>bd<CR>', { desc = 'close current buffer' })
vim.keymap.set('n', '<A-,>', '<cmd>bp<CR>', { desc = 'move to previous buffer' })
vim.keymap.set('n', '<A-.>', '<cmd>bn<CR>', { desc = 'move to next buffer' })
vim.keymap.set('n', '<A-a>', '<cmd>bufdo bd<CR>', { desc = 'close all buffers' })
vim.keymap.set('n', '<leader><leader>', 'diw', { remap = true })

vim.keymap.set({ 'x', 'n' }, 'gh', '^', { silent = true, desc = 'go to start of line' })

vim.keymap.set({ 'x', 'n' }, 'gl', '$', { silent = true, desc = 'go to end of line' })

vim.keymap.set('n', 'gi', 'gi<Esc>zzi', { silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set(
  { 'n', 'x' },
  '<Tab>',
  function()
    return vim.fn.mode() == 'V' and '<cmd>keepjumps normal! $%<CR>'
      or '<cmd>keepjumps normal! %<CR>'
  end,
  { expr = true }
)

vim.keymap.set('n', '<leader>z', 'I(<Esc>A)', { desc = 'brace line with ()' })

vim.keymap.set('n', '<leader>;', 'mzA;<Esc>`z', { desc = 'append ; at the end of line' })

vim.keymap.set('n', '<leader>,', 'mzA,<Esc>`z', { desc = 'append ; at the end of line' })

vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'go to window downward' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'go to window upward' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'go to window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'go to window right' })
vim.keymap.set('n', '<C-c>', '<C-w>q', { desc = 'close current window' })

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
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

function _G.select_md_code_block(around)
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<Esc>', true, false, false),
      'x',
      false
    )
  end

  local cur_line = vim.fn.line('.')
  local start, finish

  for linenr = cur_line, 1, -1 do
    if vim.fn.getline(linenr):match('^%s*```') then
      start = linenr
      break
    end
  end

  for linenr = cur_line, vim.fn.line('$') do
    if vim.fn.getline(linenr):match('^%s*```') then
      finish = linenr
      break
    end
  end

  if not start or not finish or start == finish then return end

  if around then
    vim.cmd(string.format([[normal! %dGV%dG]], start, finish))
  else
    vim.cmd(string.format([[normal! %dGV%dG]], start + 1, finish - 1))
  end
end

vim.keymap.set('o', 'im', '<cmd>lua select_md_code_block(false)<CR>', { silent = true })
vim.keymap.set('x', 'im', '<cmd>lua select_md_code_block(false)<CR>', { silent = true })
vim.keymap.set('o', 'am', '<cmd>lua select_md_code_block(true)<CR>', { silent = true })
vim.keymap.set('x', 'am', '<cmd>lua select_md_code_block(true)<CR>', { silent = true })

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
end, { desc = 'Toggle [L]sp [L]ines' })

vim.keymap.set(
  'n',
  '<leader>ls',
  function() vim.o.list = not vim.o.list end,
  { desc = 'Toggle [L]i[S]t char' }
)

vim.keymap.set(
  'x',
  '/',
  [[<C-\><C-n>`</\%V]],
  { desc = 'Search forward within visual selection' }
)

vim.keymap.set(
  'x',
  '?',
  [[<C-\><C-n>`>?\%V]],
  { desc = 'Search backward within visual selection' }
)

vim.keymap.set(
  'n',
  [[yx]],
  [[<cmd>let @0 = expand('<cfile>')<CR>]],
  { desc = '[Y]ank uri under cursor' }
)

vim.keymap.set(
  'n',
  [[<leader>yx]],
  [[<cmd>let @+ = expand('<cfile>')<CR>]],
  { desc = '[Y]ank uri under cursor to system clipboard' }
)

vim.keymap.set('n', 'g[', '<C-o>', { desc = '[G]oto previous jump location' })

vim.keymap.set('n', 'g]', '<C-i>', { desc = '[G]oto next jump location' })

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    local cond = bufname:find('node_modules')
    if cond then vim.bo[args.buf].modifiable = false end

    if not vim.bo[args.buf].modifiable and vim.bo[args.buf].filetype ~= 'oil' then
      vim.keymap.set(
        'n',
        [[d]],
        [[<C-d>]],
        { desc = 'scroll down', remap = true, buffer = args.buf }
      )
      vim.keymap.set(
        'n',
        [[u]],
        [[<C-u>]],
        { desc = 'scroll up', remap = true, buffer = args.buf }
      )
    end
  end,
})

vim.keymap.set('n', [[x]], [["_x]])
vim.keymap.set('n', '<M-[>', '<cmd>tabp<CR>', { desc = 'desc' })
vim.keymap.set('n', '<M-]>', '<cmd>tabn<CR>', { desc = 'desc' })
