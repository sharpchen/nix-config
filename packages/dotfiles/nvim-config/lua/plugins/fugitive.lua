return {
  enabled = false,
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>g', vim.cmd.Git, { desc = 'open git fugitive' })
  end,
}
