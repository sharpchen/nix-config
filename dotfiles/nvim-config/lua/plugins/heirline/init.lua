---@module 'lazy'
---@type LazySpec
return {
  'rebelot/heirline.nvim',
  lazy = false,
  config = function() require('plugins.heirline.heirline') end,
}
