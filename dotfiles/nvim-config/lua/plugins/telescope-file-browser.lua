return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').load_extension('file_browser')
    vim.keymap.set('n', '<leader>fr', '<cmd>Telescope file_browser<CR>', { desc = 'open project root folder' })
    vim.keymap.set(
      'n',
      '<leader>fb',
      '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>',
      { desc = 'open folder of current buffer' }
    )
  end,
}
