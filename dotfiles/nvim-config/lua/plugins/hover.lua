return {
  'lewis6991/hover.nvim',
  event = 'VeryLazy',
  config = function()
    require('hover').config {
      providers = {
        -- 'hover.providers.gh',
        -- 'hover.providers.gh_user',
        'hover.providers.lsp',
        'hover.providers.dap',
        'hover.providers.fold_preview',
        'hover.providers.diagnostic',
      },
      preview_opts = {
        border = 'single',
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = {
        'LSP',
      },
      mouse_delay = 1000,
    }

    vim.keymap.set('n', 'K', require('hover').open, { desc = 'hover.nvim' })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'help',
      callback = function(args)
        vim.keymap.set('n', 'K', '<cmd>normal! K<CR>', { buffer = args.buf })
      end,
    })
  end,
}
