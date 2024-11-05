return {
  'tpope/vim-dadbod',
  lazy = true,
  dependencies = {
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      lazy = true,
    },
    'kristijanhusak/vim-dadbod-ui',
  },

  config = function()
    require('cmp').setup.filetype({ 'sql', 'mysql', 'plsql' }, {
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })
  end,
}
