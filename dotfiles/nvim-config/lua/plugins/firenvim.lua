return {
  'glacambre/firenvim',
  cond = vim.g.started_by_firenvim,
  build = ':call firenvim#install(0)',
  config = function()
    vim.api.nvim_create_autocmd('UIEnter', {
      callback = function()
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client and client.name == 'Firenvim' then
          vim.o.laststatus = 0
          vim.o.background = 'light'
          vim.cmd.colo('xamabah')
        end
      end,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'github.com_*.txt',
      callback = function(args) vim.bo.filetype = 'markdown' end,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function(args)
        if vim.g.started_by_firenvim then
          vim.keymap.set('i', '<C-v>', '<C-r><C-p>+', { buffer = args.buf })
        end
      end,
    })

    local disable = vim
      .iter({
        'https?://github.com.*/blob/*.',
        'https?://chat.*',
        'https?://gemini.*',
        'https?://www.overleaf.com/.*',
        'https?://live.bilibili.com/.*',
        'https?://grok.*',
        'https?://www.keybr.com/.*',
      })
      :fold({}, function(sum, curr)
        sum[curr] = {
          takeover = 'never',
          priority = 1,
        }
        return sum
      end)

    vim.g.firenvim_config = {
      globalSettings = { alt = 'all' },
      localSettings = vim.tbl_extend('error', {
        ['.*'] = {
          cmdline = 'neovim',
          content = 'text',
          priority = 0,
          selector = 'textarea',
          takeover = 'always',
        },
      }, disable),
    }
  end,
}
