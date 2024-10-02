return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'davidmh/cspell.nvim',
  },
  config = function()
    local null_ls = require('null-ls')
    require('null-ls').setup({
      sources = {
        null_ls.builtins.code_actions.gitrebase,
        -- null_ls.builtins.code_actions.gitsigns,
        --#region go specific
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        --#endregion
        -- github action
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.markdownlint_cli2,
      },
    })
  end,
}
