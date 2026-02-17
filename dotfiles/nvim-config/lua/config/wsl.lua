local function set_windows_clipboard()
  local bin = vim.fn.expand('~/.local/bin')
  if vim.fn.isdirectory(bin) == 0 then vim.fn.mkdir(bin, 'p') end
  local win32yank_path = vim.fn.expand('~/.local/bin/win32yank.exe')
  local script_url =
    'https://raw.githubusercontent.com/sharpchen/clip-nvim/main/install.sh'
  if vim.uv.fs_stat(win32yank_path) == nil then
    local script_path = os.tmpname()
    vim.notify('downloading win32yank..', vim.log.levels.INFO, { title = 'WSL' })
    vim.system({
      'curl',
      '-s',
      '-o',
      script_path,
      script_url,
    }, { timeout = 10 * 1000 }, function(out)
      if out.code == 0 then
        vim.system({ 'chmod', '+x', script_path }, {}, function(out)
          if out.code == 0 then
            vim.system({ 'sh', script_path }, { timeout = 30 * 1000 }, function(out)
              if out.code == 0 then
                vim.system({ 'chmod', '+x', win32yank_path }, {}, function(out)
                  if out.code == 0 then
                    vim.notify(
                      'win32yank downloaded',
                      vim.log.levels.INFO,
                      { title = 'WSL' }
                    )
                  end
                end)
              else
                vim.notify(
                  string.format('downloading win32yank by script %s failed', script_path),
                  vim.log.levels.ERROR,
                  { title = 'WSL' }
                )
              end
            end)
          end
        end)
      else
        vim.notify(
          string.format('downloading %s failed', script_url),
          vim.log.levels.ERROR,
          { title = 'WSL' }
        )
      end
    end)
  end
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = string.format('%s -i --crlf', win32yank_path),
      ['*'] = string.format('%s -i --crlf', win32yank_path),
    },
    paste = {
      ['+'] = string.format('%s -o --lf', win32yank_path),
      ['*'] = string.format('%s -o --lf', win32yank_path),
    },
    cache_enabled = true,
  }
end

if vim.fn.has('wsl') == 1 then set_windows_clipboard() end
