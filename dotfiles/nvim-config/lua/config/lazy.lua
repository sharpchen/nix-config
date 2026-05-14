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

local lock = IsNixOS and '~/.config/home-manager/dotfiles/nvim-config/lazy-lock.json'
  or vim.fn.stdpath('config') .. '/lazy-lock.json'

require('lazy').setup {
  lockfile = lockfile,
  git = {
    url_format = 'git@github.com:%s.git',
    timeout = 60 * 10,
  },
  spec = {
    { import = 'plugins.firenvim' },
    { import = 'plugins.shared' },
    { import = 'plugins.ui', cond = not IsVscode and not IsFirenvim },
    { import = 'plugins.completion', cond = not IsVscode },
    { import = 'plugins.language-service', cond = not IsVscode and not IsFirenvim },
  },
  ui = {
    border = 'none',
  },
  install = {
    -- do not install missing plugin
    missing = not IsVscode and not IsFirenvim,
  },
}
