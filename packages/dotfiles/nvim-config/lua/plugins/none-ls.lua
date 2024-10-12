return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  enabled = false,
  config = function()
    local null_ls = require('null-ls')
    require('null-ls').setup({
      sources = {
        --#region go specific
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        --#endregion
        -- github action
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.markdownlint_cli2.with({ args = { '$FILENAME' } }),
        require('none-ls.code_actions.eslint'),
        null_ls.builtins.diagnostics.eslint,
      },
    })
  end,
}
