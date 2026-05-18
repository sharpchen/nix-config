---@module 'lazy'
---@type LazySpec
return {
  'nvim-lua/plenary.nvim',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set(
      'n',
      [[<leader>tt]],
      [[<cmd>PlenaryBustedFile %<CR>]],
      { desc = 'run plenary busted file' }
    )
    vim.keymap.set(
      'n',
      [[<leader>td]],
      [[<cmd>PlenaryBustedDirectory tests/<CR>]],
      { desc = 'run plenary busted file' }
    )
  end,
}
