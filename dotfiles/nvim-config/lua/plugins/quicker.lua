---@module 'lazy'
---@type LazySpec[]
return {
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup {
        func_map = {
          vsplit = '',
        },
      }
    end,
  },
}
