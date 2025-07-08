---@module 'lazy'
---@type LazySpec
return {
  dir = '~/projects/new-item.nvim',
  event = 'VeryLazy',
  config = function()
    require('new-item').setup { picker = 'fzf-lua' }
    local groups = require('new-item.groups')
    local file = require('new-item.item').FileItem
    local folder = require('new-item.item').FolderItem
    local cmd = require('new-item.item').CmdItem
    local util = require('new-item.util')
    groups.treesitter = {
      cond = true,
      items = {
        folder {
          label = 'test/corpus',
          cwd = function() return vim.uv.cwd() or vim.fn.getcwd() end,
        },
      },
    }
    groups.markdown = {
      cond = true,
      items = {
        file {
          label = 'Markdown file',
          filetype = 'markdown',
          suffix = '.md',
          content = [[# %s]],
        },
      },
    }
    groups.nvim = {
      cond = function()
        local path =
          vim.fs.dirname(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        return path:find(vim.fn.stdpath('config')) or path:find('nvim%-config')
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
