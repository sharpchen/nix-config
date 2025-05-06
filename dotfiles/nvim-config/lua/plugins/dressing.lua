---@module 'lazy'
---@type LazySpec
return {
  'stevearc/dressing.nvim',
  enabled = false,
  config = function()
    vim.api.nvim_set_hl(0, 'FloatTitle', { link = '@function' })
    require('dressing').setup {
      input = {
        win_options = {
          winhighlight = 'Function:Normal',
        },
      },
    }
  end,
}
