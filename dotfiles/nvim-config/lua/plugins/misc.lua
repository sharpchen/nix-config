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
    opts = {
      attach_navic = false,
      symbols = {
        separator = '▸',
      },
      kinds = require('utils.const').lsp.completion_kind_icons,
    },
  },
  {
    -- 'DaikyXendo/nvim-material-icon',
    'sharpchen/nvim-material-icon',
    branch = 'rm-invalid-icon',
    config = function()
      require('nvim-web-devicons').set_icon_by_filetype({
        msbuild = 'sln',
        axaml = 'xaml',
      })
    end,
  },
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
    'axelvc/template-string.nvim',
    ft = {
      'cs',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'svelte',
      'html',
    },
    -- enabled = false,
    config = function()
      require('template-string').setup({
        remove_template_string = true,
      })
    end,
  },
  { 'yioneko/nvim-vtsls', ft = { 'typescript', 'javascript' } },
  { 'nvchad/volt', lazy = true },
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
  {
    'nvchad/minty',
    cmd = { 'Shades', 'Huefy' },
  },
  {
    -- 'wurli/contextindent.nvim',
    -- enabled = false,
    dir = '~/projects/contextindent.nvim/',
    -- This is the only config option; you can use it to restrict the files
    -- which this plugin will affect (see :help autocommand-pattern).
    opts = { pattern = '*' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  'machakann/vim-sandwich',
}
