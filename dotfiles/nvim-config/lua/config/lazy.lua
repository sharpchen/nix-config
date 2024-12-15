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

local plugins_for_windows = vim.iter({
  'firenvim', 'telescope', 'cmp.init', 'telescope-file-browser', 'colorizer', 'Comment', 'lazygit', 'gitsigns', 'colo.vscode', 'colo.kanagawa', 'nvim-rip-substitute'
}):map(function(x) return { import = 'plugins.' .. x } end):totable()

require('lazy').setup({
  git = {
    url_format = 'git@github.com:%s.git',
  },
  spec = require('utils.env').is_windows and plugins_for_windows or { import = 'plugins' },
  ui = {
    border = 'none',
  },
})
