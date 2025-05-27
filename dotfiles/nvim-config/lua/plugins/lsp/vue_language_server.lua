local lsp = require('utils.lsp')

lsp.setup('vue_ls', {
  filetypes = { 'markdown', 'vue' },
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      -- lsp.event.abort_on_root_not_matched(client, 'package.json')
      vim.defer_fn(function() vim.lsp.stop_client(client.id) end, 200)
      lsp.event.disable_formatter(client)
    end
  end,
})
