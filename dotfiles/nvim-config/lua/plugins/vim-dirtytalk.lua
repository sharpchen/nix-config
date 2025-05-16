---@module 'lazy'
---@type LazySpec
return {
  'psliwka/vim-dirtytalk',
  build = ':DirtytalkUpdate',
  event = 'BufReadPost',
  config = function() vim.opt.spelllang:append { 'programming' } end,
}
