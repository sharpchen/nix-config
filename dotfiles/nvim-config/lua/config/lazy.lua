local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'git@github.com:folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins_for_windows = vim
  .iter({
    'firenvim',
    'colorizer',
    'Comment',
    'lazygit',
    'gitsigns',
    'colo.vscode',
    'colo.kanagawa',
    'nvim-rip-substitute',
    'nvim-autopairs',
    'oil',
    'fzf-lua',
    'treesitter',
    'which-key',
    'vim-sandwich',
    'template-string',
  })
  :map(function(x) return { import = 'plugins.' .. x } end)
  :totable()

require('lazy').setup {
  lockfile = IsWindows and vim.fn.stdpath('config') .. '/lazy-lock.json'
    or '~/.config/home-manager/dotfiles/nvim-config/lazy-lock.json',
  git = {
    url_format = 'git@github.com:%s.git',
    timeout = 60 * 10,
  },
  spec = IsWindows and plugins_for_windows or {
    { import = 'plugins' },
    { import = 'plugins.colo' },
  },
  ui = {
    border = 'none',
  },
}
