---@module 'lazy'
---@type LazySpec
return {
  'rebelot/heirline.nvim',
  lazy = false,
  init = function() _G.__default_statusline = vim.o.statusline end,
  config = function() require('plugins.heirline.heirline') end,
}
