return {
  'danymat/neogen',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('neogen').setup({ snippet_engine = 'luasnip' })
    vim.keymap.set('n', '<leader>n', '<cmd>Neogen<CR>', { desc = 'generate doc string' })
  end,
}
