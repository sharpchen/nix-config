local lsp = require('utils.lsp')
lsp.setup('emmylua_ls', {
  on_attach = lsp.event.disable_semantic,
  -- see: https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md
  settings = {
    -- lazydev currently doesn't support emmylua section
    -- see: https://github.com/folke/lazydev.nvim/pull/141
    emmylua = vim.NIL,
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true },
    },
  },
})
