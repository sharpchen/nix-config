local lsp = require('utils.lsp')

if vim.fn.executable('vtsls') == 1 then
  require('lspconfig').vtsls.setup({
    on_attach = function(client, _)
      if vim.bo.filetype == 'markdown' then
        lsp.event.disable_formatter(client)
      end
    end,
    filetypes = { 'vue', 'markdown', 'typescript', 'javascript' },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        tsserver = {
          globalPlugins = {
            {
              name = '@vue/typescript-plugin',
              location = lsp.path.vue_language_server,
              languages = { 'vue', 'markdown' },
              configNamespace = 'typescript',
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = 'literal' },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  })
else
  require('lspconfig').ts_ls.setup({
    on_attach = function(client, _)
      if vim.bo.filetype == 'markdown' then
        lsp.event.disable_formatter(client)
      end
    end,
    filetypes = { 'vue', 'markdown' },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = lsp.path.vue_language_server,
          languages = { 'vue', 'markdown' },
          configNamespace = 'typescript',
          enableForWorkspaceTypeScriptVersions = true,
        },
      },
    },
  })
end

require('lspconfig').volar.setup({
  filetypes = { 'markdown', 'vue' },
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
    end
  end,
})
