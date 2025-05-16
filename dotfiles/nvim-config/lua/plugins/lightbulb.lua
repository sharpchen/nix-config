---@diagnostic disable: missing-fields
return {
  'kosayoda/nvim-lightbulb',
  event = 'BufReadPost',
  config = function()
    require('nvim-lightbulb').setup {
      autocmd = { enabled = true },
      sign = {
        enabled = true,
        text = '',
      },
      -- float = { enabled = true }
    }
  end,
}
