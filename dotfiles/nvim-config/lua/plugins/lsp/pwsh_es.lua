local lsp = require('utils.lsp')
require('lspconfig').powershell_es.setup({
  bundle_path = lsp.path.pwsh_es,
  settings = {
    powershell = {
      codeFormatting = {
        Preset = 'OTBS',
        autoCorrectAliases = true,
        useConstantStrings = true,
        useCorrectCasing = true,
        whitespaceAroundOperator = true,
        whitespaceAfterSeparator = true,
        whitespaceBeforeOpenBrace = true,
        addWhitespaceAroundPipe = true,
      },
    },
  },
})
