---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    -- dependencies load after main spec
    -- so we can load plugins on cond or enabled
    dependencies = {
      {
        'yioneko/nvim-vtsls',
        ft = { 'typescript', 'javascript' },
        cond = require('utils.lsp').use_vtsls,
      },
    },
    config = function()
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
      lsp.setup('fsautocomplete', {
        on_init = lsp.event.disable_semantic,
      })
      lsp.setup('clangd')
      lsp.setup('neocmake')
      -- lsp.setup('csharp_ls', {
      --   on_init = lsp.event.disable_semantic,
      --   filetypes = lsp.config.ft_extend('csharp_ls', { 'axaml-cs' }),
      -- })
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
      lsp.setup('avalonia_ls', {
        name = 'avalonia_ls',
        cmd = { 'AvaloniaLanguageServer' },
        filetypes = { 'axaml' },
        root_markers = { 'App.axaml' },
        on_init = function(client)
          vim.system(
            { 'SolutionParser', client.root_dir },
            {},
            function() vim.system({ 'dotnet', 'build' }, { cwd = client.root_dir }) end
          )
        end,
      })
    end,
  },
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'axaml-cs' },
    -- enabled = false,
    config = function()
      local lsp = require('utils.lsp')

      require('roslyn').setup {
        filewatching = 'roslyn',
        cmd = {
          'Microsoft.CodeAnalysis.LanguageServer',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.log.get_filename()),
          '--stdio',
        },
      }
      vim.lsp.config('roslyn', {
        on_init = function(client) lsp.event.disable_semantic(client) end,
        filetypes = lsp.config.ft_extend('roslyn_ls', { 'axaml-cs' }),
      })
    end,
  },
  {
    'Decodetalkers/csharpls-extended-lsp.nvim',
    ft = { 'cs', 'axaml-cs' },
    config = function()
      if vim.lsp.is_enabled('csharp_ls') then
        require('csharpls_extended').buf_read_cmd_bind()
      end
    end,
  },
}
