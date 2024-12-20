return {
  'hedyhli/outline.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'toggle outline' })

    require('outline').setup({
      symbols = {
        icon_fetcher = function(kind, bufnr)
          local icons = require('utils.const').lsp.completion_kind_icons
          return icons[kind]
        end,
      },
    })
  end,
}
