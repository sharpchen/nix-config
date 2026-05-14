---@module 'lazy'
---@type LazySpec
return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    highlight = {
      keyword = 'wide_fg',
      after = 'empty',
    },
  },
}
