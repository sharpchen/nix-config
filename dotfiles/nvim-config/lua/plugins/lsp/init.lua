---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = { 'b0o/schemastore.nvim' },
    config = function()
      local lsp = require('utils.lsp')

      vim.lsp.config('*', {
        ---@diagnostic disable-next-line: param-type-not-match
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })
      -- NOTE: use LspAttach instead of on_attach for default use
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then lsp.event.default_attach(client, args.buf) end
        end,
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
      lsp.setup('bashls') -- settings: https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
      lsp.setup('emmet_language_server')
      lsp.setup('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      lsp.setup('cssls')
      lsp.setup('html')
      lsp.setup('vimls')
      lsp.setup('postgres_lsp')
      lsp.setup('marksman')
      lsp.setup('eslint')
      lsp.setup('fsautocomplete', {
        on_attach = lsp.event.disable_semantic,
      })
      lsp.setup('clangd')
      lsp.setup('neocmake')
      -- lsp.setup('csharp_ls', {
      --   on_init = lsp.event.disable_semantic,
      --   filetypes = lsp.config.ft_extend('csharp_ls', { 'axaml-cs' }),
      -- })
      -- vim.lsp.config('roslyn_ls', {
      --   on_init = function(client) lsp.event.disable_semantic(client) end,
      --   filetypes = lsp.config.ft_extend('roslyn_ls', { 'axaml-cs' }),
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

      -- require('plugins.lsp.lua_ls')
      lsp.setup('emmylua_ls', {
        on_attach = lsp.event.disable_semantic,
        settings = {
          Lua = {
            completion = {
              autoRequire = false,
              displayContext = 1,
            },
            hint = {
              enable = true,
              paramName = 'Literal',
              semicolon = 'Disable',
            },
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'need-check-nil' },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      })
      require('plugins.lsp.yamlls')
      require('plugins.lsp.vue_language_server')
      require('plugins.lsp.pwsh_es')
      require('plugins.lsp.msbuild_ls')
      require('plugins.lsp.query_ls')
      require('plugins.lsp.lemminx')
      require('plugins.lsp.ds_pinyin_lsp')
      require('plugins.lsp.nixd')

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
    ft = { 'cs', 'axaml-cs' },
    config = function()
      if vim.lsp.is_enabled('csharp_ls') then
        require('csharpls_extended').buf_read_cmd_bind()
      end
    end,
  },
  {
    'yioneko/nvim-vtsls',
    ft = { 'typescript', 'javascript' },
    cond = require('utils.lsp').use_vtsls,
  },
}
