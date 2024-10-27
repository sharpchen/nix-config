return {
  'hedyhli/outline.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'toggle outline' })

    require('outline').setup({
      -- Your setup opts here (leave empty to use defaults)
    })
  end,
}
