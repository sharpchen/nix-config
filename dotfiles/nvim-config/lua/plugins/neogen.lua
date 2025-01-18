return {
  'danymat/neogen',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('neogen').setup({
      enabled = true,
      snippet_engine = 'luasnip',
      languages = {
        cs = {
          template = {
            annotation_convention = 'xmldoc',
          },
        },
        lua = {
          template = {
            annotation_convention = 'emmylua',
          },
        },
      },
    })

    vim.keymap.set('n', '<leader>n', '<cmd>Neogen<CR>', { desc = 'generate doc annotation' })
  end,
}
