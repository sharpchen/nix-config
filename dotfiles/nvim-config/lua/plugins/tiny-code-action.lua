return {
  'rachartier/tiny-code-action.nvim',
  enabled = false,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
  },
  event = 'LspAttach',
  config = function()
    require('tiny-code-action').setup()
    vim.keymap.set('n', '<leader>ca', require('tiny-code-action').code_action, { noremap = true, silent = true })
  end,
}
