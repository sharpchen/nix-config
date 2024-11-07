local lsp = require('utils.lsp')

require('lspconfig').ts_ls.config_def = vim.tbl_deep_extend('error', require('lspconfig').ts_ls.config_def, {
  filetypes = { 'vue', 'markdown' },
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = lsp.path.vue_language_server,
        languages = { 'vue', 'markdown' },
      },
    },
  },
})

require('lspconfig').volar.setup({
  filetypes = { 'markdown', 'vue' },
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
    end
  end,
})
