return {
  'nvim-neo-tree/neo-tree.nvim',
  enabled = false,
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false,
  config = function()
    require('neo-tree').setup({
      window = {
        position = 'left',
        width = 30,
      },
      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
        },
      },
    })

    vim.keymap.set(
      'n',
      '<leader>pv',
      ':Neotree toggle current reveal_force_cwd<CR>',
      { desc = 'neo-tree go back to project view', silent = true }
    )

    vim.keymap.set(
      'n',
      '<leader>n',
      ':Neotree float git_status<CR>',
      { desc = 'show floating neo-tree', silent = true }
    )

    vim.keymap.set('n', '<leader>b', ':Neotree toggle<CR>', { desc = 'toggle neo-tree', silent = true })

    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        vim.cmd('Neotree action=close')
      end,
    })
  end,
}
