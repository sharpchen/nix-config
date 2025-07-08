return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },

  config = function()
    vim.api.nvim_create_autocmd('TermEnter', {
      callback = function(args)
        if vim.api.nvim_buf_get_name(args.buf):find('lazygit') then
          vim.keymap.set('t', '<Esc>', function()
            local chan = vim.b[args.buf].terminal_job_id
            if chan then vim.api.nvim_chan_send(chan, vim.keycode('<Esc>')) end
          end, { buffer = args.buf })
        end
      end,
    })
  end,
}
