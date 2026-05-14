---@module 'lazy'
---@type LazySpec
return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPre', 'BufNewFile' },
  enabled = false,
  config = function()
    require('illuminate').configure {
      filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'qf',
      },
    }
  end,
}
