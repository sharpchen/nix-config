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
    {
      'davesavic/dadbod-ui-yank',
      dependencies = { 'kristijanhusak/vim-dadbod-ui' },
      config = function() require('dadbod-ui-yank').setup() end,
    },
  },

  config = function() end,
}
