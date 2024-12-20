local lsp = require('utils.lsp')
require('lspconfig').vtsls.setup({
  filetypes = { 'vue', 'markdown', 'typescript', 'javascript' },
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
    end
  end,
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
