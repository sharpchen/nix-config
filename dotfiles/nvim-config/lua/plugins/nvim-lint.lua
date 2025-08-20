---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      javascript = { 'eslint' },
      sql = { 'sqlfluff' },
      plsql = { 'sqlfluff' },
      nix = { 'nix' },
      fsharp = { 'fsharplint' },
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      callback = function() lint.try_lint() end,
    })
  end,
}
