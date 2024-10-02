return {
  enabled = false,
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  },
  init = function()
    vim.g.barbar_auto_setup = false

    vim.keymap.set('n', '<A-c>', ':BufferClose<CR>', { desc = 'close current buffer', silent = true })
    vim.keymap.set('n', '<A-,>', ':BufferPrevious<CR>', { desc = 'move to previous buffer', silent = true })
    vim.keymap.set('n', '<A-.>', ':BufferNext<CR>', { desc = 'move to next buffer', silent = true })
    vim.keymap.set('n', '<A-a>', ':BufferCloseAllButCurrent<CR>', { desc = 'close all buffers', silent = true })
  end,
  opts = {
    animation = true,
    insert_at_start = true,
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
