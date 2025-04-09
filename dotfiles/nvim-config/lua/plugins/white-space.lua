return {
  -- 'johnfrankmorgan/whitespace.nvim',
  dir = '~/projects/whitespace.nvim/',
  config = function()
    require('whitespace-nvim').setup {
      highlight = 'DiffDelete',
      ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
      ignore_terminal = true,
      return_cursor = true,
    }
    vim.keymap.set('n', '<Leader>tr', require('whitespace-nvim').trim)
  end,
}
