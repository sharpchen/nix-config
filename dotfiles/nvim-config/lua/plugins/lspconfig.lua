return vim.fn.executable('nix') == 1
    and {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
        require('lspconfig.ui.windows').default_options.border = 'rounded'
        local function disable_semantic(client)
          client.server_capabilities.semanticTokensProvider = nil
        end
        require('lspconfig').lua_ls.setup({
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
        require('lspconfig').taplo.setup({})

        require('lspconfig').ts_ls.setup({
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = require('utils.static').lsp.vue_language_server,
                languages = { 'vue', 'markdown' },
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        })

        require('lspconfig').volar.setup({
          filetypes = { 'markdown' },
        })

        -- require('lspconfig').vtsls.setup({
        --   settings = {
        --     complete_function_calls = true,
        --     vtsls = {
        --       enableMoveToFileCodeAction = true,
        --       autoUseWorkspaceTsdk = true,
        --     },
        --     tsserver = {
        --       globalPlugins = {
        --         vue,
        --       },
        --     },
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
              userDictPath = '~/.config/home-manager/dotfiles/harper_dict.txt',
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
        require('lspconfig').jsonls.setup({})
        require('lspconfig').cssls.setup({})
        require('lspconfig').html.setup({})
        require('lspconfig').vimls.setup({})
        require('lspconfig').yamlls.setup({
          settings = {
            yaml = {
              schemas = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = '/*.k8s.yaml',
              },
            },
          },
        })
      end,
    }
  or {}
