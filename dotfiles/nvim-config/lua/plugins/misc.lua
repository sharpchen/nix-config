return {
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('illuminate').configure({
        filetypes_denylist = {
          'dirbuf',
          'dirvish',
          'qf',
        },
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  'onsails/lspkind.nvim',
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    event = { 'BufReadPre', 'BufNewFile' },
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    opts = {},
  },
  {
    'DaikyXendo/nvim-material-icon',
    config = function()
      local xaml_icon, xaml_color = require('nvim-web-devicons').get_icon_color('', 'xaml')
      require('nvim-web-devicons').set_icon({
        axaml = {
          icon = xaml_icon,
          color = xaml_color,
          name = 'axaml',
        },
      })
      require('nvim-web-devicons').setup({
        override_by_extension = {
          ['c++'] = {
            icon = '',
            color = '#0188d1',
            cterm_color = '32',
            name = 'cpp',
          },
          ['h++'] = {
            icon = '',
            color = '#0188d1',
            cterm_color = '32',
            name = 'hpp',
          },
        },
      })
    end,
  },
  'rebelot/heirline.nvim',
  { 'ThePrimeagen/vim-be-good', lazy = true },
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
  {
    'sharpchen/template-string.nvim',
    ft = { 'cs', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'html' },
    -- enabled = false,
    config = function()
      require('template-string').setup({
        remove_template_string = true,
      })
    end,
  },
  'yioneko/nvim-vtsls',
  { 'nvchad/volt', lazy = true },
  {
    'nvchad/minty',
    cmd = { 'Shades', 'Huefy' },
  },
  'rebelot/kanagawa.nvim',
  'Mofiqul/vscode.nvim',
}
