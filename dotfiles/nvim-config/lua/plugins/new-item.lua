---@module 'lazy'
---@type LazySpec
return {
  dir = '~/projects/new-item.nvim',
  event = 'VeryLazy',
  submodules = true,
  config = function()
    require('new-item').setup {
      picker = { name = 'snacks' },
      init = function(groups, ctors)
        groups.md = {
          cond = true,
          items = {
            ctors.file {
              iname = 'markdown',
              label = 'Markdown file',
              filetype = 'markdown',
              suffix = '.md',
              content = '# %s',
            },
          },
        }
        groups.config:append {
          ctors.file {
            iname = 'stylua',
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
            ctors.file {
              iname = 'lazyplug',
              label = 'Lazy plug',
              content = vim.text.indent(
                0,
                [[
              ---@module 'lazy'
              ---@type LazySpec
              return {

              }]]
              ),
              filetype = 'lua',
              suffix = '.lua',
            },
          },
        }
      end,
    }

    vim.keymap.set('n', [[<leader>ni]], [[<cmd>NewItem<CR>]], { desc = 'desc' })
  end,
}
