---@module 'lazy'
---@type LazySpec
return {
  'glacambre/firenvim',
  lazy = not vim.g.started_by_firenvim,
  module = false,
  build = ':call firenvim#install(0)',
  config = function()
    vim.api.nvim_create_autocmd('UIEnter', {
      callback = function()
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client and client.name == 'Firenvim' then
          vim.o.guifont = 'IBM Plex Mono'
          vim.o.laststatus = 0
          vim.o.background = 'light'
          if not pvimcmd { cmd = 'colo', args = { 'xamabah' } } then
            vim.cmd.colo('default')
          end

          if IsWindows then
            vim.system(
              Env.shell.powershell_cmd(
                [[Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme]]
              ),
              { text = true },
              function(out)
                if out.code == 0 then
                  local number = tonumber(vim.trim(out.stdout))
                  local light = number and number == 1
                  if not light then
                    vim.schedule(function() vim.cmd.colo('habamax') end)
                  end
                end
              end
            )
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = {
        'github.com_*.txt',
        'gitlab.com_*.txt',
        'codeberg.org_*.txt',
      },
      callback = function(args) vim.bo.filetype = 'markdown' end,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function(args)
        if vim.g.started_by_firenvim then
          vim.keymap.set('i', '<C-v>', '<C-r><C-p>+', { buffer = args.buf })
        end
      end,
    })

    local enable = vim
      .iter({
        'https?://github\\.com/.*',
        'https?://gitlab\\.com/.*',
        'https?://codeberg\\.org/.*',
      })
      :fold({}, function(sum, curr)
        sum[curr] = {
          priority = 1,
          cmdline = 'neovim',
          content = 'text',
          selector = 'textarea:not([readonly], [aria-readonly]), div[role="textbox"]',
          takeover = 'always',
        }
        return sum
      end)

    vim.g.firenvim_config = {
      globalSettings = { alt = 'all' },
      localSettings = vim.tbl_extend('error', {
        ['.*'] = {
          takeover = 'never',
        },
      }, enable),
    }
  end,
}
