local lsp = require('utils.lsp')

require('lspconfig').volar.setup({
  filetypes = { 'markdown', 'vue' },
  on_attach = function(client, _)
    if vim.bo.filetype == 'markdown' then
      lsp.event.disable_formatter(client)
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  pattern = '*.md',
  callback = function()
    local root = require('utils.io').DirectoryInfo.new(vim.uv.cwd())
    if #root:get_files('package%.json') == 0 then
      vim.notify('No project found, stopped language server for md')
      vim.cmd(('LspStop %s'):format(require('utils.lsp').use_vtsls and 'vtsls' or 'ts_ls'))
    end
  end,
  desc = [[disable language server for js/ts when it's not a node project]],
})
