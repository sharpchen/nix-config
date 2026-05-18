vim.g.mapleader = vim.keycode('<space>')

vim.keymap.set(
  'x',
  [[<leader>:]],
  function() return vim.bo.filetype == 'lua' and [["zy:=<C-r>z]] or [["zy:<C-r>z]] end,
  { desc = 'send selection to cmdline', expr = true }
)

vim.keymap.set('n', '<leader>gq', function()
  local cword = vim.fn.expand('<cword>')
  local format =
    [[:sil grep! '\b%s\b' | cw<Left><Left><Left><Left><Left><Left><Left><Left>]]
  return string.format(format, cword ~= '' and '<C-r><C-w>' or '')
end, { desc = '[G]rep and pipe to [Q]f', expr = true })

vim.keymap.set(
  'n',
  '<leader>gQ',
  [[:sil grep!  | cw<Left><Left><Left><Left><Left>]],
  { desc = '[G]rep and pipe to [Q]f' }
)

vim.keymap.set(
  'x',
  '<leader>gq',
  [["zy:sil grep! '<C-r>z' | cw<Left><Left><Left><Left><Left>]],
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

vim.keymap.set('n', '<leader>i', '<cmd>Inspect<CR>', { desc = 'Inspect' })

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf, silent = true, nowait = true }
    -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    -- gi was a builtin keymap, not using go to implementation now
    -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set(
      'n',
      '<leader>hh',
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 })
      end,
      opts
    )
  end,
})

---@param opts { around: boolean }
local function select_md_code_block(opts)
  local mode = vim.api.nvim_get_mode().mode

  if mode == 'v' or mode == 'V' or mode == vim.keycode('<C-v>') then
    vim.cmd('normal! ' .. vim.keycode([[<C-\><C-n>]]))
  end

  local finish = vim.fn.search([[^\s*```]], 'n')
  local start = vim.fn.search([[^\s*```\(\w*\)\?]], 'bn')

  if not start or not finish or start == finish then return end

  if not opts.around then
    start = start + 1
    finish = finish - 1
  end

  vim.api.nvim_win_set_cursor(0, { start, 0 })
  vim.cmd([[normal! V]])
  vim.api.nvim_win_set_cursor(0, { finish, 0 })
end

vim.keymap.set({ 'x', 'o' }, 'im', function() select_md_code_block { around = false } end)
vim.keymap.set({ 'x', 'o' }, 'am', function() select_md_code_block { around = true } end)

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

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if vim.bo[args.buf].filetype == 'oil' then return end

    local bufname = vim.api.nvim_buf_get_name(args.buf)
    local cond = vim.bo[args.buf].readonly
      or bufname:match('node_modules')
      or bufname:match('.*glibc.*/include/')
      or bufname:match('%.log$')
      or bufname:match('^/nix/store/')
      or bufname:match('.*%.cache.+')
      or bufname:match('%.venv/lib')
      or vim.startswith(bufname, vim.env.VIMRUNTIME)

    if cond then vim.bo[args.buf].modifiable = false end

    if not vim.bo[args.buf].modifiable then
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

vim.keymap.set(
  'n',
  ']d',
  function() vim.diagnostic.jump { count = 1 } end,
  { desc = 'goto next diagnostic' }
)
vim.keymap.set(
  'n',
  '[d',
  function() vim.diagnostic.jump { count = -1 } end,
  { desc = 'goto previous diagnostic' }
)
vim.keymap.set(
  'n',
  [[<leader>cd]],
  [[<cmd>tchdir %:h<CR>]],
  { desc = 'change dir to current parent' }
)

vim.keymap.set('n', '<leader>m', '<cmd>make | cwindow<CR>')

vim.keymap.set({ 'n', 'x', 'o' }, '<A-n>', function()
  local ok, ts_select = pcall(require, 'vim.treesitter._select')
  if not ok then
    vim.notify(
      'remap.lua: `vim.treesitter._select` is missing/deprecated.',
      vim.log.levels.WARN
    )
  end

  if not ts_select.select_parent then
    vim.notify(
      'remap.lua: `vim.treesitter._select::select_parent` is missing/deprecated.',
      vim.log.levels.WARN
    )
  end

  if
    ok
    and ts_select.select_parent
    and vim.treesitter.get_parser(nil, nil, { error = false })
  then
    ts_select.select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end)

vim.keymap.set({ 'n', 'x', 'o' }, '<A-m>', function()
  local ok, ts_select = pcall(require, 'vim.treesitter._select')
  if not ok then
    vim.notify(
      'remap.lua: `vim.treesitter._select` is missing/deprecated.',
      vim.log.levels.WARN
    )
  end

  if not ts_select.select_child then
    vim.notify(
      'remap.lua: `vim.treesitter._select::select_child` is missing/deprecated.',
      vim.log.levels.WARN
    )
  end

  if
    ok
    and ts_select.select_child
    and vim.treesitter.get_parser(nil, nil, { error = false })
  then
    ts_select.select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end)
