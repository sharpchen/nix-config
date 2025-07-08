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
  { 'nvchad/volt', lazy = true },
  {
    'nvchad/minty',
    cmd = { 'Shades', 'Huefy' },
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
  {
    'johnfrankmorgan/whitespace.nvim',
    event = 'BufReadPost',
    config = function()
      require('whitespace-nvim').setup {
        highlight = 'DiffDelete',
        ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
        ignore_terminal = true,
        return_cursor = true,
      }
      vim.keymap.set('n', '<Leader>tr', require('whitespace-nvim').trim)
      -- highlight would disappear for conflicting with au in set.lua
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = require('whitespace-nvim').highlight,
      })
    end,
  },
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    event = 'BufReadPost',
    config = function() vim.opt.spelllang:append { 'programming' } end,
  },
  {
    'ravibrock/spellwarn.nvim',
    event = 'VeryLazy',
    config = function()
      require('spellwarn').setup {
        ft_default = false,
        ft_config = {
          markdown = true,
        },
      }
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    event = 'BufReadPost',
    config = function()
      require('nvim-lightbulb').setup {
        autocmd = { enabled = true },
        sign = {
          enabled = true,
          text = '',
        },
        -- float = { enabled = true }
      }
    end,
  },
}
