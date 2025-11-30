local lsp = require('utils.lsp')
lsp.setup('emmylua_ls', {
  on_attach = lsp.event.disable_semantic,
  settings = {
    Lua = {
      completion = {
        autoRequire = false,
        displayContext = 1,
      },
      hint = {
        enable = true,
        paramName = 'Literal',
        semicolon = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        -- requirePattern = {
        --   'lua/?.lua',
        --   'lua/?/init.lua',
        --   '?/lua/?.lua', -- this allows plugins to be loaded
        --   '?/lua/?/init.lua',
        -- },
      },
      diagnostics = {
        globals = { 'vim' },
        disable = { 'need-check-nil' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})
