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
        init_options = {
          -- see: https://github.com/PowerShell/PowerShellEditorServices/blob/ba8b42071c097536d240e857b2b1cf3dcd1e1fbc/src/PowerShellEditorServices/Server/PsesLanguageServer.cs#L157-L158
          enableProfileLoading = false,
        },
        settings = {
          -- see: https://github.com/PowerShell/PowerShellEditorServices/blob/ba8b42071c097536d240e857b2b1cf3dcd1e1fbc/src/PowerShellEditorServices/Services/Workspace/LanguageServerSettings.cs#L464
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
