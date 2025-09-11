return {
  'glacambre/firenvim',
  cond = IsWindows,
  build = ':call firenvim#install(0)',
  config = function()
    vim.api.nvim_create_autocmd('UIEnter', {
      callback = function()
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client and client.name == 'Firenvim' then
          vim.o.laststatus = 0
          vim.o.background = 'light'
        end
      end,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'github.com_*.txt',
      callback = function(args)
        vim.bo.filetype = 'markdown'
        vim.keymap.set('i', '<C-v>', '<C-r><C-p>+', { buffer = args.buf })
      end,
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
        ['https?://github.com.*/blob/*.'] = {
          takeover = 'never',
          priority = 1,
        },
        ['https?://chat.*'] = { -- disable for ai chat
          takeover = 'never',
          priority = 1, -- priority matters to override the .* pattern
        },
        ['https?://gemini.*'] = {
          takeover = 'never',
          priority = 1,
        },
        ['https?://www.overleaf.com/.*'] = {
          takeover = 'never',
          priority = 1,
        },
        ['https?://live.bilibili.com/.*'] = {
          takeover = 'never',
          priority = 1,
        },
      },
    }
  end,
}
