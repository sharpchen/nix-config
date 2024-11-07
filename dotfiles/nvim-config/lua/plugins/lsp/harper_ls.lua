require('lspconfig').harper_ls.setup({
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
