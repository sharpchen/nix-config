-- line number
vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- use space as indentation
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.conceallevel = 0 -- do not hide identifiers with highlight group with conceal=true

vim.opt.hlsearch = false -- disable search result highlight
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')
vim.opt.guicursor =
  'n-v-sm:block-blinkwait700-Cursor,ci-ve:ver25,r-cr-o:hor20,i-c:ver100-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

if vim.fn.executable('rg') == 1 then vim.opt.grepprg = 'rg --vimgrep --pcre2 ' end
vim.opt.spell = true
vim.opt.spelloptions = 'camel'

-- vim.opt.iskeyword:remove { '_' }
vim.opt.showmode = false

-- render listchars on colorcolumn loaded
-- local listchars = [[nbsp:␣,eol:↵,space:·,tab:» ]]
local listchars = [[nbsp:␣,eol:↵,tab:» ]]
vim.o.list = true
vim.o.listchars = listchars
vim.cmd([[2match WhiteSpaceBol /^ \+/]])
vim.cmd('match WhiteSpaceMol / /')
vim.api.nvim_set_hl(0, 'WhiteSpaceMol', {
  fg = string.format('#%x', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 16777215),
})
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.o.list = true
    vim.o.listchars = listchars
    vim.cmd([[2match WhiteSpaceBol /^ \+/]])
    vim.cmd('match WhiteSpaceMol / /')
    vim.api.nvim_set_hl(0, 'WhiteSpaceMol', {
      fg = string.format(
        '#%x',
        vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 16777215
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
    foo = 'foo',
    axaml = 'axaml',
    xaml = 'xaml',
    props = 'msbuild',
    tasks = 'msbuild',
    targets = 'msbuild',
    vsvimrc = 'vim',
    ideavimrc = 'vim',
    inputrc = 'sh',
  },
  pattern = {
    ['.*%..+proj'] = 'msbuild',
    sshconfig = 'sshconfig',
  },
}

vim.treesitter.language.register('xml', { 'axaml', 'xaml', 'msbuild' })

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

vim.opt.fillchars = {
  diff = '╱',
}

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

    if args.event == 'DirChanged' then vim.notify('DirChanged to ' .. cwd) end

    if cwd and cwd:find('playground') then
      vim.opt.autochdir = true
    else
      vim.opt.autochdir = false
    end

    if vim.fs.root(0, function(name, _) return name:match('%.%w+proj$') ~= nil end) then
      vim.g.dotnet_errors_only = true
      vim.g.dotnet_show_project_file = false
      vim.cmd.compiler('dotnet')
    end

    if
      vim.fs.root(0, function(name, _) return name:match('tsconfig%.json$') ~= nil end)
    then
      local suffix = ' tsc --noEmit'
      local exe = vim.fn.executable('pnpm') == 1 and 'pnpm' or 'npx'
      vim.g.tsc_makeprg = exe .. suffix
      vim.cmd.compiler('tsc')
    end
  end,
})

vim.api.nvim_create_user_command(
  'Rename',
  [[execute $'saveas {expand('%:p:h')}/{"<args>"}' | call delete(expand('#'))]],
  { desc = 'Rename current file', nargs = 1 }
)
