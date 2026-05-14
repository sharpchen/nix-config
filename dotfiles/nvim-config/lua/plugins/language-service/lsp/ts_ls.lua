local lsp = require('utils.lsp')
lsp.setup('ts_ls', {
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.abort_on_root_not_matched(client, 'package.json')
      lsp.event.disable_formatter(client)
    end
  end,
  filetypes = lsp.config.ft_extend('ts_ls', { 'vue', 'markdown' }),
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
