vim.cmd.source(vim.fn.expand('~/.vimrc'))

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

if IsWindows then
  require('config.windows')
elseif IsLinux then
  require('config.linux')
end

vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')
vim.opt.guicursor =
  'n-v-sm:block-blinkwait700-Cursor,ci-ve:ver25,r-cr-o:hor20,i-c:ver100-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

vim.o.foldenable = true
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'indent'
vim.opt.fillchars:append {
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
}

if vim.fn.executable('rg') == 1 then vim.opt.grepprg = 'rg --vimgrep --pcre2 ' end
vim.opt.spell = true
vim.opt.spelloptions:append { 'camel', 'noplainbuffer' }
vim.opt.spelllang:append { 'cjk' } -- disable spellcheck for East Asian characters

-- render listchars on colorcolumn loaded
-- local listchars = [[nbsp:␣,eol:↵,space:·,tab:» ]]
local listchars = [[nbsp:␣,eol:↵,tab:» ]]
vim.o.list = true
vim.o.listchars = listchars
vim.cmd([[2match WhiteSpaceBol /^ \+/]])
vim.cmd('match WhiteSpaceMol / /')
vim.api.nvim_set_hl(0, 'WhiteSpaceMol', {
  fg = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0xFFFFFF),
})
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.o.list = true
    vim.o.listchars = listchars
    vim.cmd([[2match WhiteSpaceBol /^ \+/]])
    vim.cmd('match WhiteSpaceMol / /')
    vim.api.nvim_set_hl(0, 'WhiteSpaceMol', {
      fg = string.format(
        '#%06x',
        vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0xFFFFFF
      ),
    })
  end,
})

_G.__diag_fmt = function(diagnostic)
  ---@cast diagnostic vim.Diagnostic
  if diagnostic.code and diagnostic.source and diagnostic.message then
    return string.format(
      '[%s] %s [%s]',
      diagnostic.code,
      diagnostic.message,
      diagnostic.source
    )
  elseif diagnostic.code and diagnostic.message then
    return string.format(
      '[%s] %s',
      diagnostic.code,
      diagnostic.message,
      diagnostic.source
    )
  else
    return diagnostic.message
  end
end

vim.diagnostic.config {
  virtual_text = {
    prefix = ' ■ ', -- Could be '●', '▎', 'x', '■', , 
    source = true,
    format = _G.__diag_fmt,
  },
  update_in_insert = true,
  underline = true,
  float = {
    border = 'single',
    source = true,
    format = _G.__diag_fmt,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require('utils.const').lsp.diagnostic_icons.Error,
      [vim.diagnostic.severity.WARN] = require('utils.const').lsp.diagnostic_icons.Warn,
      [vim.diagnostic.severity.HINT] = require('utils.const').lsp.diagnostic_icons.Hint,
      [vim.diagnostic.severity.INFO] = require('utils.const').lsp.diagnostic_icons.Info,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
    },
  },
}

vim.opt.formatoptions:remove { 'c', 'r', 'o' }

vim.filetype.add {
  extension = {
    axaml = 'axaml',
    xaml = 'xaml',
    props = 'msbuild',
    tasks = 'msbuild',
    targets = 'msbuild',
    vsvimrc = 'vim',
    ideavimrc = 'vim',
    inputrc = 'sh',
    gitconfig = 'gitconfig',
    slnx = 'slnx',
  },
  pattern = {
    ['.*%..+proj'] = 'msbuild',
    sshconfig = 'sshconfig',
    ['.*axaml%.cs'] = 'axaml-cs',
  },
  filename = {
    ['Settings.XamlStyler'] = 'json',
  },
}

vim.treesitter.language.register('xml', { 'axaml', 'xaml', 'msbuild', 'slnx' })
vim.treesitter.language.register('c_sharp', { 'axaml-cs' })

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zvzz',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank { timeout = 300 } end,
})

vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

vim.opt.fillchars:append { diff = '╱' }

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:12',
  'algorithm:histogram',
  'linematch:200',
  'indent-heuristic',
}

vim.api.nvim_create_autocmd({ 'DirChanged', 'VimEnter' }, {
  callback = function(args)
    local cwd = vim.uv.cwd()
    local should_change_dir = cwd and cwd:find('playground') ~= nil

    if args.event == 'VimEnter' then vim.opt.autochdir = should_change_dir end

    if args.event == 'DirChanged' then vim.notify('DirChanged to ' .. cwd) end

    local use_global_compiler = args.event == 'VimEnter' and not vim.opt.autochdir

    Env.set_compiler {
      buf = args.buf,
      global = use_global_compiler,
    }
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(args)
    if vim.opt.autochdir then
      Env.set_compiler {
        buf = args.buf,
        global = false,
      }
    end
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(_) vim.opt_local.spell = false end,
  desc = 'disable spell in terminal',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function() vim.opt_local.spell = false end,
})

vim.api.nvim_create_user_command(
  'LspLog',
  string.format('e %s', vim.lsp.log.get_filename()),
  { desc = 'open lsp log' }
)

vim.api.nvim_create_user_command('Playground', function(e)
  local ft = vim.bo.filetype
  -- NOTE: scratch buffer would attach lsp
  -- see tracking issue: https://github.com/neovim/neovim/issues/36775
  local buf = vim.api.nvim_create_buf(true, true)

  if e.args ~= '' then
    vim.bo[buf].filetype = e.args
  else
    vim.bo[buf].filetype = ft
  end

  vim.api.nvim_set_current_buf(buf)
end, {
  nargs = '?',
  complete = 'filetype',
  desc = 'Open a playground buffer in current filetype',
})

vim.api.nvim_create_user_command(
  'Edit',
  function(e) vim.cmd.edit(vim.fs.joinpath(vim.fn.expand('%:p:h'), e.args)) end,
  { nargs = 1 }
)
vim.api.nvim_create_user_command(
  'E',
  function(e) vim.cmd.edit(vim.fs.joinpath(vim.fn.expand('%:p:h'), e.args)) end,
  { nargs = 1 }
)

vim.api.nvim_create_user_command('W', 'noautocmd w', { desc = 'pure write' })

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = { 'habamax', 'xamabah' },
  callback = function(args)
    vim.cmd('hi WinSeparator guibg=none')
    local highlight = require('utils.static').highlight
    local normal = highlight.get('Normal')

    if args.match == 'habamax' then
      local visual_bg = highlight.get('Identifier').fg
      highlight.set('Visual', { fg = normal.bg, bg = visual_bg })
    elseif args.match == 'xamabah' then
      highlight.override('Cursor', { fg = 'red' })
    end

    highlight.set('NormalFloat', { bg = normal.bg })
    highlight.set('@variable', { fg = normal.fg })
    highlight.set('Operator', { link = 'Keyword' })
  end,
})

vim.api.nvim_create_user_command('Readonly', function(args)
  vim.bo.modifiable = false

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
end, { desc = 'make current buffer readonly' })

if not vim.g.started_by_firenvim then
  vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
    callback = function()
      local bg = require('utils.static').highlight.get('Normal').bg
      if bg then
        vim.api.nvim_ui_send(string.format('\x1b]11;%s\a', string.format('#%06x', bg)))
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'VimLeavePre', 'VimSuspend' }, {
    callback = function() vim.api.nvim_ui_send('\x1b]111\a') end,
  })
end

function _findfunc(arglead)
  local files = vim.fn.systemlist('fd --type file --full-path --color never')

  local matches = vim.fn.matchfuzzy(
    files,
    arglead,
    { text_cb = function(s) return vim.fs.basename(s) end }
  )
  return #matches > 0 and matches or files
end

vim.o.findfunc = 'v:lua._findfunc'
