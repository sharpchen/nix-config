return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  enabled = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function()
    require('telescope').setup({
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_cursor({}),
        },
        file_browser = {
          hidden = { file_browser = true, folder_browser = false },
          layout_config = {
            preview_width = 0.5,
            width = 0.95,
          },
        },
      },
      defaults = {
        -- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
    })

    require('telescope').load_extension('ui-select')

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({
        cwd = vim.uv.cwd(),
        hidden = true,
        layout_config = {
          preview_width = 0.5,
          width = 0.95,
        },
      })
    end, { desc = 'find in all files in project' })
    vim.keymap.set('n', '<leader>fpf', function()
      local ok, _ = pcall(builtin.git_files, {
        layout_config = {
          preview_width = 0.5,
          width = 0.95,
        },
      })
      if not ok then
        vim.notify('Current project is NOT a git repo.', vim.log.levels.WARN)
      end
    end, { desc = 'find in all tracked files' })

    vim.keymap.set('n', '<leader>fg', function()
      builtin.live_grep({ layout_config = { preview_width = 0.5, width = 0.95 } })
    end, { desc = 'grep from files' })

    vim.keymap.set('n', '<leader>fc', function()
      local config_path = vim.uv.os_uname().sysname == 'Windows_NT' and '~/AppData/Local/nvim'
        or '~/.config/home-manager/dotfiles/nvim-config/'
      builtin.find_files({
        cwd = config_path,
        layout_config = {
          preview_width = 0.5,
          width = 0.95,
        },
      })
    end, { desc = 'find nvim config file' })

    vim.keymap.set('n', '<leader>fh', function()
      builtin.help_tags({
        layout_config = {
          preview_width = 0.5,
          width = 0.95,
        },
      })
    end, { desc = 'find help tags' })
  end,
}
