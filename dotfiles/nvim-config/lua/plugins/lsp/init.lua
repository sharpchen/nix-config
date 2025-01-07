return {
  'neovim/nvim-lspconfig',
  -- dir = '~/projects/nvim-lspconfig/',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    vim.api.nvim_create_user_command('LspLog', string.format('e %s', vim.lsp.get_log_path()), {
      desc = 'open lsp log',
    })
    local lsp = require('utils.lsp')
    require('lspconfig.ui.windows').default_options.border = 'rounded'
    local lspconfig = require('lspconfig')
    lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      on_attach = lsp.event.default_attach,
    })

    require('lspconfig').taplo.setup({})
    require('plugins.lsp.lua_ls')
    require('plugins.lsp.yamlls')

    if lsp.use_vtsls then
      require('plugins.lsp.vtsls')
    else
      require('plugins.lsp.ts_ls')
    end
    require('lspconfig').quick_lint_js.setup({})
    require('plugins.lsp.vue_language_server')
    require('plugins.lsp.pwsh_es')
    require('plugins.lsp.msbuild_ls')
    require('plugins.lsp.harper_ls')

    require('lspconfig').lemminx.setup({
      filetypes = { 'xaml', 'axaml' },
    })
    require('lspconfig').nixd.setup({
      on_init = function(client)
        lsp.event.disable_semantic(client)
        lsp.event.disable_formatter(client)
      end,
    })
    require('lspconfig').bashls.setup({})
    require('lspconfig').emmet_language_server.setup({})
    require('lspconfig').jsonls.setup({})
    require('lspconfig').cssls.setup({})
    require('lspconfig').html.setup({})
    require('lspconfig').vimls.setup({})
    require('lspconfig').postgres_lsp.setup({})
    require('lspconfig').marksman.setup({})
  end,
}
