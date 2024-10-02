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
    })
    vim.keymap.set({ 'v', 'x' }, '<leader>e', ":'<,'>SnipRun<CR>")
  end,
}
