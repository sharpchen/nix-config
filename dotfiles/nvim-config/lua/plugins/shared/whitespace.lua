---@module 'lazy'
---@type LazySpec
return {
  'johnfrankmorgan/whitespace.nvim',
  event = 'BufReadPost',
  config = function()
    require('whitespace-nvim').setup {
      highlight = 'DiffDelete',
      ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard', 'dbout' },
      ignore_terminal = true,
      return_cursor = true,
    }
    vim.keymap.set('n', '<Leader>tr', require('whitespace-nvim').trim)
    -- highlight would disappear for conflicting with au in set.lua
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = require('whitespace-nvim').highlight,
    })

    vim.api.nvim_create_autocmd('BufWritePost', {
      callback = function(args)
        if vim.list_contains({ 'markdown', 'ps1' }, vim.bo[args.buf].filetype) then
          require('whitespace-nvim').trim()
        end
      end,
    })
  end,
}
