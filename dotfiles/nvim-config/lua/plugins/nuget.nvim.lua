return {
  'd7omdev/nuget.nvim',
  enabled = false,
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function() require('nuget').setup() end,
}
