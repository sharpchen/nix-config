return {
  'rcarriga/nvim-notify',
  dependencies = {
    {
      'mrded/nvim-lsp-notify',
      enabled = false,
      config = function()
        require('lsp-notify').setup {
          notify = require('notify'),
        }
      end,
    },
  },
  config = function()
    require('notify').setup {
      timeout = 1000,
      top_down = false,
      render = 'wrapped-compact',
      merge_duplicates = false,
    }
    vim.notify = require('notify')
  end,
}
