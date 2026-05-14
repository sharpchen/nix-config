if HasNix then
  require('utils.async').cmd(
    require('utils.env').nix_store_query('powershell-editor-services'),
    function(result)
      require('utils.lsp').path.pwsh_es =
        vim.fs.joinpath(result, 'lib/powershell-editor-services')

      local lsp = require('utils.lsp')
      lsp.setup('powershell_es', {
        on_attach = function(client) lsp.event.disable_semantic(client) end,
        bundle_path = lsp.path.pwsh_es,
        -- see: https://github.com/PowerShell/vscode-powershell/blob/main/src/settings.ts
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
      })
    end
  )
end
