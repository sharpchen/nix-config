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
    ft = { 'sql' },
  },
  {
    'davesavic/dadbod-ui-yank',
    ft = { 'sql' },
    dependencies = { 'kristijanhusak/vim-dadbod-ui' },
    config = function() require('dadbod-ui-yank').setup() end,
  },
}
