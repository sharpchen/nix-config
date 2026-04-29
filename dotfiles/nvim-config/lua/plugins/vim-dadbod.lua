return {
  {
    'kristijanhusak/vim-dadbod-completion',
    ft = { 'sql' },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'tpope/vim-dadbod',
    },
    event = 'VeryLazy',
  },
  {
    'davesavic/dadbod-ui-yank',
    dependencies = { 'kristijanhusak/vim-dadbod-ui' },
    config = function() require('dadbod-ui-yank').setup() end,
  },
}
