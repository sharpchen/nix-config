return {
  'williamboman/mason.nvim',
  enabled = false, -- vim.fn.executable('nix') == 0,
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('lspconfig.ui.windows').default_options.border = 'rounded'
    require('mason').setup({ ui = { border = 'rounded' } })
    require('mason-tool-installer').setup({
      ensure_installed = {
        'vtsls',
        'lua_ls',
        'ast_grep',
        'bashls',
        'jsonls',
        'powershell_es',
        'lemminx',
        'yamlls',
        'volar',
        'tailwindcss',
        'html-lsp',
        'css-lsp',
        'stylua',
        'shfmt',
        'fsautocomplete',
        'actionlint',
      },
    })
  end,
}
