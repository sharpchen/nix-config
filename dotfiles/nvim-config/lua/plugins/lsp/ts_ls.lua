local lsp = require('utils.lsp')
require('lspconfig').ts_ls.setup({
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
    end
  end,
})
