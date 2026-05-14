require('utils.lsp').setup('lemminx', {
  filetypes = require('utils.lsp').config.ft_extend('lemminx', { 'msbuild', 'slnx' }),
  -- lemminx does not have tabSize control using json rpc
  on_init = require('utils.lsp').event.disable_formatter,
})
