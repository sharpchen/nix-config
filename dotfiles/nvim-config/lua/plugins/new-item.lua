---@module 'lazy'
---@type LazySpec
return {
  dir = '~/projects/new-item.nvim',
  event = 'VeryLazy',
  submodules = true,
  config = function()
    require('new-item').setup { picker = { name = 'snacks', preview = false } }
    local groups = require('new-item.groups')
    local file = require('new-item.items').FileItem
    local folder = require('new-item.items').FolderItem
    local cmd = require('new-item.items').CmdItem
    local util = require('new-item.util')
    groups.md = {
      cond = true,
      items = {
        file {
          label = 'Markdown file',
          filetype = 'markdown',
          suffix = '.md',
          content = '# %s',
        },
      },
    }
    groups.config:append {
      file {
        label = 'stylua',
        link = vim.fn.expand('~/.config/.stylua.toml'),
        filetype = 'toml',
        suffix = '.toml',
        default_name = '.stylua',
        nameable = false,
        cwd = function() return vim.fn.getcwd() end,
      },
    }
    groups.nvim = {
      cond = function()
        local path =
          vim.fs.dirname(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        return path:find(vim.fn.stdpath('config')) ~= nil
          or path:find('nvim%-config') ~= nil
      end,
      items = {
        file {
          label = 'Lazy plug',
          content = util.dedent([[
            ---@module 'lazy'
            ---@type LazySpec
            return {

            }]]),
          filetype = 'lua',
          suffix = '.lua',
        },
      },
    }
    vim.keymap.set('n', [[<leader>ni]], [[<cmd>NewItem<CR>]], { desc = 'desc' })
  end,
}
