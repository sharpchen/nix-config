vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function(args)
    vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', {
      buffer = args.buf,
      silent = true,
      desc = 'make current file executable',
    })
  end,
})
