return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
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
        zoxide = {
          prompt_title = '[ Walking on the shoulders of TJ ]',
          mappings = {
            default = {
              after_action = function(selection)
                print('Update to (' .. selection.z_score .. ') ' .. selection.path)
              end,
            },
            ['<C-s>'] = {
              before_action = function(selection)
                print('before C-s')
              end,
              action = function(selection)
                vim.cmd.edit(selection.path)
              end,
            },
            -- Opens the selected entry in a new split
            ['<C-q>'] = { action = require('telescope._extensions.zoxide.utils').create_basic_command('split') },
          },
        },
      },
      defaults = {
        -- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
    })

    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('zoxide')

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
        or '~/.config/home-manager/packages/dotfiles/nvim-config/'
      builtin.find_files({
        cwd = config_path,
        layout_config = {
          preview_width = 0.5,
          width = 0.95,
        },
      })
    end, { desc = 'find nvim config file' })
  end,
}
