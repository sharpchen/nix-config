require('lspconfig').lua_ls.setup {
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
}
