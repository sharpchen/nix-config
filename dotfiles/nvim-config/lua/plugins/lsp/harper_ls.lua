require('lspconfig').harper_ls.setup {
  filetypes = require('utils.lsp').config.filetypes('harper_ls', { 'ps1' }),
  settings = {
    ['harper-ls'] = {
      linters = {
        sentence_capitalization = false,
      },
      codeActions = {
        forceStable = true,
      },
      userDictPath = '~/.config/home-manager/dotfiles/harper_dict.txt',
    },
  },
}
