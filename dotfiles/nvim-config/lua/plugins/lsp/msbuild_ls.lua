require('utils.lsp').setup('msbuild_project_tools_server', {
  cmd = { 'MSBuildProjectTools.LanguageServer.Host' },
  filetypes = { 'msbuild' },
  on_attach = function(client)
    client.server_capabilities.completionProvider = {
      resolveProvider = false,
      triggerCharacters = { '<' },
    }
  end,
})
