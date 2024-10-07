return vim.fn.executable('nix') == 1
    and {
      'neovim/nvim-lspconfig',
      config = function()
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
        require('lspconfig.ui.windows').default_options.border = 'rounded'
        local function disable_semantic(client)
          client.server_capabilities.semanticTokensProvider = nil
        end
        require('lspconfig').lua_ls.setup({
          capabilities = lsp_capabilities,
          settings = {
            Lua = {
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
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            },
          },
        })
        require('lspconfig').taplo.setup({
          capabilities = lsp_capabilities,
        })
        -- require('lspconfig').biome.setup({
        --   capabilities = lsp_capabilities,
        -- })
        -- require('lspconfig').vtsls.setup({
        --   settings = {
        --     typescript = {
        --       inlayHints = {
        --         parameterNames = { enabled = 'literal' },
        --         parameterTypes = { enabled = true },
        --         variableTypes = { enabled = true },
        --         propertyDeclarationTypes = { enabled = true },
        --         functionLikeReturnTypes = { enabled = true },
        --         enumMemberValues = { enabled = true },
        --       },
        --     },
        --   },
        -- })
        require('lspconfig').harper_ls.setup({
          settings = {
            ['harper-ls'] = {
              linters = {
                sentence_capitalization = false,
              },
              codeActions = {
                forceStable = true,
              },
            },
          },
        })
        require('lspconfig').lemminx.setup({
          filetypes = { 'xaml', 'axaml' },
        })
        require('lspconfig').nixd.setup({
          on_init = disable_semantic,
        })
        require('lspconfig').quick_lint_js.setup({})
        require('lspconfig').ast_grep.setup({})
        require('lspconfig').fsautocomplete.setup({})
        require('lspconfig').bashls.setup({})
        require('lspconfig').emmet_language_server.setup({})
        require('lspconfig').ts_ls.setup({})
        require('lspconfig').jsonls.setup({
          capabilities = lsp_capabilities,
        })
        require('lspconfig').cssls.setup({
          capabilities = lsp_capabilities,
        })
        require('lspconfig').html.setup({
          capabilities = lsp_capabilities,
        })
      end,
    }
  or {}
