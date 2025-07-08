---@module 'lazy'
---@type LazySpec
return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_create_user_command(
        'LspLog',
        string.format('e %s', vim.lsp.get_log_path()),
        { desc = 'open lsp log' }
      )

      local lsp = require('utils.lsp')

      --#region delete this when all ls were managed by vim.lsp
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      local lspconfig = require('lspconfig')
      lspconfig.util.default_config =
        vim.tbl_extend('force', lspconfig.util.default_config, {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
          on_attach = lsp.event.default_attach,
        })
      --#endregion

      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        on_attach = lsp.event.default_attach,
      })

      if lsp.use_vtsls then
        require('plugins.lsp.vtsls')
      else
        require('plugins.lsp.ts_ls')
      end

      lsp.setup('taplo')
      lsp.setup('quick_lint_js', {
        on_attach = function(client, _)
          if vim.fs.root(0, 'tree-sitter.json') then vim.lsp.stop_client(client.id) end
        end,
      })
      lsp.setup('bashls')
      lsp.setup('emmet_language_server')
      lsp.setup('jsonls')
      lsp.setup('cssls')
      lsp.setup('html')
      lsp.setup('vimls')
      lsp.setup('postgres_lsp')
      lsp.setup('marksman')
      lsp.setup('eslint')
      lsp.setup('fsautocomplete')
      lsp.setup('clangd')
      lsp.setup('neocmake')
      -- lsp.setup('csharp_ls', {
      --   on_attach = lsp.event.disable_semantic,
      -- })
      lsp.setup('roslyn_ls', {
        on_attach = lsp.event.disable_semantic,
      })
      lsp.setup('basedpyright', {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
        },
        python = {
          analysis = {
            ignore = { '*' },
          },
        },
      })
      lsp.setup('ruff', {
        on_attach = function(client)
          -- disable this if using basedpyright as language server
          client.server_capabilities.hoverProvider = false
        end,
      })

      require('plugins.lsp.lua_ls')
      require('plugins.lsp.yamlls')
      require('plugins.lsp.vue_language_server')
      require('plugins.lsp.pwsh_es')
      require('plugins.lsp.msbuild_ls')
      require('plugins.lsp.query_ls')
      require('plugins.lsp.lemminx')

      lsp.setup('nixd', {
        on_init = function(client)
          lsp.event.disable_semantic(client)
          lsp.event.disable_formatter(client)
        end,
      })
    end,
  },
  { 'yioneko/nvim-vtsls', ft = { 'typescript', 'javascript' } },
}
