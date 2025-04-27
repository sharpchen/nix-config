local lsp = require('utils.lsp')

lsp.setup('volar', {
  filetypes = { 'markdown', 'vue' },
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then lsp.event.disable_formatter(client) end
  end,
})
