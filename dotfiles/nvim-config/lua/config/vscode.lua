if not vim.g.vscode then
  return
end

require('config.remap')
require('config.set')
require('utils')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'git@github.com:folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins_for_vscode = vim
  .iter({
    'Comment',
    'nvim-rip-substitute',
    'nvim-autopairs',
    'oil',
    'template-string',
    'vim-sandwich',
    'treesitter',
  })
  :map(function(x)
    return { import = 'plugins.' .. x }
  end)
  :totable()

require('lazy').setup({
  lockfile = jit.os:find('Windows') and vim.fn.stdpath('config') .. '/lazy-lock.json'
    or '~/.config/home-manager/dotfiles/nvim-config/lazy-lock.json',
  git = {
    url_format = 'git@github.com:%s.git',
    timeout = 60 * 10,
  },
  spec = plugins_for_vscode,
  ui = {
    border = 'none',
  },
})

local vscode = require('vscode')

vim.keymap.set('n', '<leader>k', [[<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>]])
vim.keymap.set('i', '<C-k>', '<C-p>')
vim.keymap.set('i', '<C-j>', '<C-n>')
vim.keymap.set('n', [[\]], function()
  vscode.action('editor.actions.findWithArgs', {
    args = {
      searchString = vim.fn.expand('<cword>'),
      replaceString = '',
      isRegex = true,
      preserveCase = true,
      isCaseSensitive = true,
    },
  })
end)
vim.keymap.set('v', [[\]], function()
  vscode.action('editor.actions.findWithArgs', {
    args = {
      searchString = vim.fn.expand('<cword>'),
      replaceString = '',
      isRegex = true,
      preserveCase = true,
      isCaseSensitive = true,
      findInSelection = true,
    },
  })
end)
