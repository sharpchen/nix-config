require('utils.lsp').setup('harper_ls', {
  -- filetypes = require('utils.lsp').config.ft_extend('harper_ls', { 'ps1' }),
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
})
