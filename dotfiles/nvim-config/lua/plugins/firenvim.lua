return {
  'glacambre/firenvim',
  enabled = jit.os:find('Windows'),
  build = ':call firenvim#install(0)',
  config = function()
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      pattern = 'github.com_*.txt',
      command = 'set filetype=markdown',
    })

    vim.g.firenvim_config = {
      globalSettings = { alt = 'all' },
      localSettings = {
        ['.*'] = {
          cmdline = 'neovim',
          content = 'text',
          priority = 0,
          selector = 'textarea',
          takeover = 'always',
        },
        ['https?://chat.*'] = { -- disable for ai chat
          takeover = 'never',
          priority = 1, -- priority matters to override the .* pattern
        },
        ['https?://www.overleaf.com/.*'] = {
          takeover = 'never',
          priority = 1,
        },
      },
    }
  end,
}
