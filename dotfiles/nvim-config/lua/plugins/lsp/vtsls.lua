local lsp = require('utils.lsp')
lsp.setup('vtsls', {
  filetypes = lsp.config.ft_extend('vtsls', { 'vue', 'markdown' }),
  on_attach = function(client, bufnr)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
      lsp.event.abort_on(client, 'package.json')
    else
      lsp.event.attach_navic(client, bufnr)
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
