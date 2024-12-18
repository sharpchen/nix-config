return {
  'michaelb/sniprun',
  branch = 'master',
  build = 'sh install.sh 1',
  config = function()
    require('sniprun').setup({
      display = {
        selected_interpreters = { 'Lua_nvim', 'Generic' },
        'VirtualText',
        'Classic',
      },
      interpreter_options = {
        Generic = {
          error_truncate = 'long', -- strongly recommended to figure out what's going on
          nix_config = { -- any key name is ok
            supported_filetypes = { 'nix' },
            extension = '.nix',
            interpreter = 'nix eval --raw -f',
          },
        },
      },
    })
    vim.keymap.set({ 'v', 'x' }, '<leader>e', ":'<,'>SnipRun<CR>")
  end,
}
