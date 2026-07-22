---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    -- event = { 'BufReadPre', 'BufNewFile' },
    -- don't lazy load otherwise lsp config from 'exrc' might got overridden
    lazy = false,
    dependencies = { 'b0o/schemastore.nvim' },
    config = function()
      -- NOTE: use LspAttach instead of on_attach for default use
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then Lsp.event.default_attach(client, args.buf) end
        end,
      })

      require('plugins.language-service.lsp.vtsls')
      -- Lsp.setup('tsgo', {
      --   on_attach = function(client)
      --     if vim.lsp.is_enabled('oxfmt') then Lsp.event.disable_formatter(client) end
      --     Lsp.event.disable_semantic(client)
      --   end,
      -- })

      Lsp.setup('taplo')
      Lsp.setup('bashls') -- settings: https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
      Lsp.setup('emmet_language_server')
      Lsp.setup('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      Lsp.setup('cssls')
      Lsp.setup('html')

      -- see: https://github.com/oxc-project/oxc/tree/main/crates/oxc_language_server
      Lsp.setup('oxlint')
      Lsp.setup('oxfmt', {
        workspace_required = false,
      })
      Lsp.setup('vimls')
      Lsp.setup('postgres_lsp')
      Lsp.setup('marksman')
      Lsp.setup('eslint')
      Lsp.setup('clangd', {
        on_attach = Lsp.event.disable_semantic,
      })
      -- lsp.setup('csharp_ls', {
      --   on_init = lsp.event.disable_semantic,
      --   filetypes = lsp.config.ft_extend('csharp_ls', { 'axaml-cs' }),
      -- })

      Lsp.setup('zuban')
      Lsp.setup('ruff')

      -- require('plugins.language-service.lsp.lua_ls')
      require('plugins.language-service.lsp.emmylua')
      require('plugins.language-service.lsp.yamlls')
      require('plugins.language-service.lsp.vue_language_server')

      if Env.has_dotnet then
        if Env.has_pwsh then require('plugins.language-service.lsp.pwsh_es') end

        Lsp.setup('roslyn_ls', {
          on_attach = function(client) Lsp.event.disable_semantic(client) end,
          filetypes = Lsp.config.ft_extend('roslyn_ls', { 'axaml-cs' }),
        })

        require('plugins.language-service.lsp.msbuild_ls')

        Lsp.setup('fsautocomplete', {
          on_attach = Lsp.event.disable_semantic,
        })

        Lsp.setup('avalonia_ls', {
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
      end

      require('plugins.language-service.lsp.query_ls')
      require('plugins.language-service.lsp.lemminx')
      require('plugins.language-service.lsp.ds_pinyin_lsp')
      require('plugins.language-service.lsp.nixd')
    end,
  },
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'axaml-cs' },
    dependencies = { 'neovim/nvim-lspconfig' },
    enabled = false
      and Env.has_dotnet
      and (
        vim.fn.executable('roslyn-language-server') == 1
        or vim.fn.executable('Microsoft.CodeAnalysis.LanguageServer') == 1
      ),
    config = function()
      local lsp = require('utils.lsp')

      require('roslyn').setup {
        filewatching = 'roslyn',
      }
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'roslyn' then
            lsp.event.disable_semantic(client)
          end
        end,
      })
      vim.lsp.config('roslyn', {
        filetypes = lsp.config.ft_extend('roslyn_ls', { 'axaml-cs' }),
      })
    end,
  },
  {
    'Decodetalkers/csharpls-extended-lsp.nvim',
    enabled = Env.has_dotnet and vim.fn.executable('csharp-ls') == 1,
    ft = { 'cs', 'axaml-cs' },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      if vim.lsp.is_enabled('csharp_ls') then
        require('csharpls_extended').buf_read_cmd_bind()
      end
    end,
  },
  {
    'yioneko/nvim-vtsls',
    dependencies = { 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'javascript' },
    cond = require('utils.lsp').use_vtsls,
  },
}
