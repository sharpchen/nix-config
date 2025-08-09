---@module 'lazy'
---@type LazySpec
return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  config = function()
    vim.keymap.set(
      'x',
      '<leader>me',
      ':Refactor extract ',
      { desc = '[E]xtract selection' }
    )
    vim.keymap.set(
      'x',
      '<leader>mf',
      ':Refactor extract_to_file ',
      { desc = '[E]xtract selection to file' }
    )

    vim.keymap.set(
      'x',
      '<leader>mv',
      ':Refactor extract_var ',
      { desc = '[E]xtract selection to variable' }
    )

    vim.keymap.set({ 'n', 'x' }, '<leader>mi', ':Refactor inline_var')

    vim.keymap.set('n', '<leader>mI', ':Refactor inline_func')

    vim.keymap.set('n', '<leader>mb', ':Refactor extract_block')
    vim.keymap.set('n', '<leader>mbf', ':Refactor extract_block_to_file')
  end,
}
