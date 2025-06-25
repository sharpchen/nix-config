---@module 'lazy'
---@type LazySpec[]
return {
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = false,
    config = function()
      require('illuminate').configure {
        filetypes_denylist = {
          'dirbuf',
          'dirvish',
          'qf',
        },
      }
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      highlight = {
        keyword = 'wide_fg',
        after = 'empty',
      },
    },
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    enabled = false,
    event = 'VeryLazy',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    opts = {
      attach_navic = false,
      symbols = {
        separator = '▸',
      },
      kinds = require('utils.const').lsp.completion_kind_icons,
    },
  },
  {
    'DaikyXendo/nvim-material-icon',
    -- 'sharpchen/nvim-material-icon',
    -- branch = 'rm-invalid-icon',
    event = 'VeryLazy',
    config = function()
      require('nvim-web-devicons').set_icon_by_filetype {
        msbuild = 'sln',
        axaml = 'xaml',
        sh = 'bash',
      }
    end,
  },
  { 'LunarVim/bigfile.nvim', event = { 'BufReadPre', 'BufNewFile' } },
  {
    'tree-sitter-grammars/tree-sitter-test',
    -- compile on your own on Windows
    build = 'make parser/test.so',
    ft = 'test',
    init = function()
      -- toggle full-width rules for test separators
      vim.g.tstest_fullwidth_rules = false
      -- set the highlight group of the rules
      vim.g.tstest_rule_hlgroup = 'FoldColumn'
    end,
  },
  { 'yioneko/nvim-vtsls', ft = { 'typescript', 'javascript' } },
  { 'nvchad/volt', lazy = true },
  {
    'nvzone/typr',
    event = 'VeryLazy',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
  {
    'nvchad/minty',
    cmd = { 'Shades', 'Huefy' },
  },
  {
    'sharpchen/contextindent.nvim',
    branch = 'cindent',
    -- This is the only config option; you can use it to restrict the files
    -- which this plugin will affect (see :help autocommand-pattern).
    opts = { pattern = '*.md' },
  },
  {
    'nvzone/showkeys',
    event = 'VeryLazy',
    cmd = 'ShowkeysToggle',
    opts = {
      maxkeys = 5,
    },
  },
  {
    dir = '~/projects/new-item.nvim',
    event = 'VeryLazy',
    config = function()
      require('new-item').setup { picker = 'fzf-lua' }
      local groups = require('new-item.groups')
      local file = require('new-item.item').FileItem
      local folder = require('new-item.item').FolderItem
      local cmd = require('new-item.item').CmdItem
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
      -- require('new-item.groups').dotnet = {
      --   items = {
      --     {
      --       content = [[
      --       Console.WriteLine("Hello, World")
      --       ]],
      --       name_customizable = true,
      --     },
      --   },
      -- }
      vim.keymap.set('n', [[<leader>ni]], [[<cmd>NewItem<CR>]], { desc = 'desc' })
    end,
  },

  {
    'nvim-lua/plenary.nvim',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set(
        'n',
        [[<leader>tf]],
        [[<cmd>PlenaryBustedFile %<CR>]],
        { desc = 'run plenary busted file' }
      )
      vim.keymap.set(
        'n',
        [[<leader>td]],
        [[<cmd>PlenaryBustedDirectory tests/<CR>]],
        { desc = 'run plenary busted file' }
      )
    end,
  },
  'laytan/cloak.nvim',
}
