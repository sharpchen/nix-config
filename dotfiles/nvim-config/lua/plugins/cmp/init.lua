return {
  'hrsh7th/nvim-cmp',
  enabled = false,
  branch = 'main',
  event = { 'BufReadPre', 'BufNewFile', 'CmdlineEnter' },
  version = false,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'uga-rosa/cmp-dictionary',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
    'hrsh7th/cmp-nvim-lua',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'xzbdmw/colorful-menu.nvim',
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      build = 'make install_jsregexp',
    },
  },
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()

    require('cmp').setup.filetype('rip-substitute', {
      enabled = false,
    })

    local cmp = require('cmp')

    require('cmp').setup.global({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      preselect = 'item',
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      experimental = {
        ghost_text = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })

    require('cmp_dictionary').setup({
      paths = { '~/.config/home-manager/en.dict' },
      exact_length = 2,
    })
    require('plugins.cmp.format')
    require('plugins.cmp.source')
    require('plugins.cmp.sort')
    require('plugins.cmp.mapping')
    require('plugins.cmp.cmd')
  end,
}
