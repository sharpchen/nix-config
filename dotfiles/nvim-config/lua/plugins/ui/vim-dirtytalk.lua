---@module 'lazy'
---@type LazySpec
return {
  'psliwka/vim-dirtytalk',
  enabled = not IsWindows, -- build-time requires bash
  build = ':DirtytalkUpdate',
  event = 'BufReadPost',
  init = function() vim.opt.spelllang:append { 'programming' } end,
}
