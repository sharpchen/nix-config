return vim.fn.executable('nix') == 1
    and {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lsp = require('utils.lsp')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
        require('lspconfig.ui.windows').default_options.border = 'rounded'

        require('lspconfig').taplo.setup({})
        require('plugins.lsp.lua_ls')
        require('plugins.lsp.yamlls')

        require('plugins.lsp.ts_ls')
        require('plugins.lsp.vtsls')
        require('lspconfig').quick_lint_js.setup({})
        require('plugins.lsp.vue_language_server')

        require('plugins.lsp.harper_ls')
        require('lspconfig').lemminx.setup({
          filetypes = { 'xaml', 'axaml' },
        })
        require('lspconfig').nixd.setup({
          on_init = lsp.event.disable_semantic,
        })
        require('lspconfig').bashls.setup({})
        require('lspconfig').emmet_language_server.setup({})
        require('lspconfig').jsonls.setup({})
        require('lspconfig').cssls.setup({})
        require('lspconfig').html.setup({})
        require('lspconfig').vimls.setup({})
        require('lspconfig').postgres_lsp.setup({})
      end,
    }
  or {}
