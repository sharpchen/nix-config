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
  'n-v-sm:block-blinkwait700-blinkoff400-blinkon250-Cursor,ci-ve:ver25,r-cr-o:hor20,i-c:ver100-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

for type, icon in pairs(require('utils.const').lsp.diagnostic_icons) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- render listchars on colorcolumn loaded
vim.opt.showmode = false
local listchars = [[nbsp:␣,eol:↵,space:·,tab:» ]]
vim.o.list = true
vim.o.listchars = listchars
vim.cmd([[2match WhiteSpaceBol /^ \+/]])
vim.cmd('match WhiteSpaceMol / /')
vim.api.nvim_set_hl(0, 'WhiteSpaceMol', {
  fg = string.format('#%x', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0),
})
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.o.list = true
    vim.o.listchars = listchars
    vim.cmd([[2match WhiteSpaceBol /^ \+/]])
    vim.cmd('match WhiteSpaceMol / /')
    vim.api.nvim_set_hl(0, 'WhiteSpaceMol', {
      fg = string.format('#%x', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0),
    })
  end,
})

vim.diagnostic.config({
  virtual_text = {
    prefix = ' ■ ', -- Could be '●', '▎', 'x', '■', , 
  },
  update_in_insert = true,
  underline = true,
  float = { border = 'rounded' },
})
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove('c')
    vim.opt_local.formatoptions:remove('r')
    vim.opt_local.formatoptions:remove('o')
  end,
})

vim.filetype.add({
  extension = {
    axaml = 'axaml',
    xaml = 'xaml',
    props = 'msbuild',
    tasks = 'msbuild',
    targets = 'msbuild',
    slnx = 'msbuild',
  },
  pattern = {
    [ [[.*\..*proj]] ] = 'msbuild',
  },
})

vim.treesitter.language.register('xml', { 'axaml', 'xaml', 'msbuild' })

if jit.os:find('Windows') and vim.fn.executable('pwsh') == 1 then
  vim.o.shell = 'pwsh'
end

vim.api.nvim_create_user_command('Pj', function()
  local cmd = [[cmd.exe /c "for /D %d in (%USERPROFILE%\projects\*) do @echo %d" | fzf]]
  local pwsh = [[gci -dir -path ~/projects | % FullName]]
  local bash = [[ls -d ~/projects/* | cat - <(echo -n "${HOME}/.config/home-manager/")]]
  local command = (vim.o.shell:find('pwsh') or vim.o.shell:find('powershell')) and pwsh
    or vim.o.shell:find('cmd') and cmd
    or bash

  require('fzf-lua').fzf_exec(command, {
    actions = {
      ['default'] = function(selected, _)
        vim.fn.chdir(selected[1])
      end,
    },
  })
end, { desc = 'switch to one project folder' })

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zvzz',
})
