require('lspconfig').lemminx.setup({
  filetypes = require('utils.lsp').config.filetypes('lemminx', { 'xaml', 'axaml', 'msbuild' }),
  -- lemminx does not have tabSize control using json rpc
  on_init = require('utils.lsp').event.disable_formatter,
})
