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
          content = [[# %s]],
        },
      },
    }
    groups.lua = {
      cond = function()
        return vim.fs.root(vim.fn.expand('%:p:h'), { 'init.lua', '.git' }) ~= nil
      end,
      items = {
        file {
          label = 'stylua',
          link = vim.fn.expand('~/.config/.stylua.toml'),
          filetype = 'toml',
          suffix = '.toml',
          default_name = '.stylua',
          nameable = false,
          cwd = function() return vim.fn.getcwd() end,
        },
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
    groups.dotnet:append {
      file {
        label = 'CLASS',
        suffix = '.cs',
        filetype = 'cs',
        content = util.dedent([[
        namespace <ns>;

        public class %s {

        }
        ]]),
        before_creation = function(item, ctx)
          local proj
          vim.fs.root(ctx.cwd, function(name, path)
            if name:match('%.%w+proj$') then proj = vim.fs.joinpath(path, name) end
          end)
          local root_ns, ns
          vim
            .system(
              { 'dotnet', 'msbuild', proj, '-getProperty:RootNamespace' },
              { text = true },
              function(out)
                if out.code == 0 then root_ns = vim.trim(out.stdout) end
              end
            )
            :wait()
          local rel = vim.fs.relpath(vim.fs.dirname(proj), ctx.cwd)
          if rel and rel ~= '.' then
            ns = root_ns .. '.' .. rel:gsub('/', '.')
          else
            ns = root_ns
          end
          item.content = item.content:gsub('<ns>', ns)
          return item, ctx
        end,
      },
    }
    vim.keymap.set('n', [[<leader>ni]], [[<cmd>NewItem<CR>]], { desc = 'desc' })
  end,
}
