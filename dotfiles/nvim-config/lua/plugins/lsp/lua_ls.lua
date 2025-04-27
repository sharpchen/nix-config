require('utils.lsp').setup('lua_ls', {
  settings = {
    Lua = {
      hint = {
        enable = true,
        paramName = 'Literal',
        semicolon = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})
