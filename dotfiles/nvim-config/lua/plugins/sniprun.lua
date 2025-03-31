return {
  'michaelb/sniprun',
  branch = 'master',
  build = 'sh install.sh 1',
  config = function()
    require('sniprun').setup({
      display = {
        'VirtualText',
        'Classic',
      },
      selected_interpreters = { 'Lua_nvim', 'Generic' },
      interpreter_options = {
        Generic = {
          error_truncate = 'long', -- strongly recommended to figure out what's going on
          nix = { -- any key name is ok
            supported_filetypes = { 'nix' },
            extension = '.nix',
            interpreter = 'nix eval --raw -f',
          },
          ps1 = {
            supported_filetypes = { 'ps1' },
            extension = '.ps1',
            interpreter = 'pwsh -noprofile -nologo -f',
          },
        },
      },
    })

    vim.keymap.set({ 'v', 'x' }, '<leader>e', ":'<,'>SnipRun<CR>", { desc = 'sniprun' })
    vim.keymap.set(
      'n',
      '<leader>e',
      require('utils.static').mark.wrap(function()
        vim.cmd('SnipRun')
      end),
      { desc = 'sniprun' }
    )
  end,
}
