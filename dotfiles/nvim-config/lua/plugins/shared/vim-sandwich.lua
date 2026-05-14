---@module 'lazy'
---@type LazySpec
return {
  'machakann/vim-sandwich',
  event = 'BufReadPost',
  config = function()
    -- ib textobject conflicts with mini.ai
    vim.cmd('unmap ib')
  end,
}
