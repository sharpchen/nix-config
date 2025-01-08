local lsp = require('utils.lsp')
require('lspconfig').ts_ls.setup({
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
    end
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
    'markdown',
  },
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
