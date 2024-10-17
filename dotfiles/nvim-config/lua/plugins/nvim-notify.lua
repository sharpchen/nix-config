return {
  'rcarriga/nvim-notify',
  dependencies = {
    {
      'mrded/nvim-lsp-notify',
      enabled = false,
      config = function()
        require('lsp-notify').setup({
          notify = require('notify'),
        })
      end,
    },
  },
  config = function()
    require('notify').setup({
      timeout = 1000,
      top_down = false,
      render = 'wrapped-compact',
    })
    vim.notify = require('notify')

    vim.keymap.set('n', '<leader>fn', ':Telescope notify<CR>', { silent = true, desc = 'open notify' })
  end,
}
