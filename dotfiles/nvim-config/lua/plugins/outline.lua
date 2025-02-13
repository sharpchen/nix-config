return {
  'hedyhli/outline.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'epheien/outline-treesitter-provider.nvim',
  },
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'toggle outline' })

    local icons = require('utils.const').lsp.completion_kind_icons
    require('outline').setup({
      symbol_folding = {
        markers = { '▸', '▾' },
      },
      symbols = {
        icon_fetcher = function(kind, bufnr)
          return icons[kind]
        end,
        icons = {
          Object = { icon = icons.Variable, hl = 'Variable' },
          Namespace = { icon = icons.Module, hl = 'Type' },
          String = { icon = icons.Text, hl = 'String' },
          Array = { icon = '[]', hl = 'Variable' },
        },
      },
      providers = {
        priority = { 'markdown', 'lsp', 'norg', 'treesitter' },
        markdown = {
          filetypes = { 'markdown' },
        },
      },
    })
  end,
}
