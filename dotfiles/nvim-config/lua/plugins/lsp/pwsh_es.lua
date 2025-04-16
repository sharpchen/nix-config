local lsp = require('utils.lsp')
require('lspconfig').powershell_es.setup {
  on_attach = function(client) lsp.event.disable_semantic(client) end,
  bundle_path = lsp.path.pwsh_es,
  settings = {
    powershell = {
      codeFormatting = {
        preset = 'OTBS',
        autoCorrectAliases = true,
        useConstantStrings = true,
        useCorrectCasing = true,
        whitespaceAroundOperator = true,
        whitespaceAfterSeparator = true,
        whitespaceBeforeOpenBrace = true,
        addWhitespaceAroundPipe = true,
        alignPropertyValuePairs = true,
      },
    },
  },
}
