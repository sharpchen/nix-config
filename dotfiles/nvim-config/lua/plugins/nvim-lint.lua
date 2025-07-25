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
    lint.linters.fsharplint = {
      name = 'fsharplint',
      cmd = 'dotnet-fsharplint',
      args = { '--format', 'msbuild', 'lint' },
      stdin = false,
      append_fname = true,
      stream = 'stdout',
      ignore_exitcode = true,
      parser = require('lint.parser').from_errorformat(
        [=[%f(%.%#\,%.%#\,%l\,%c):FSharpLint\ %tarning %m]=],
        {
          source = 'fsharplint',
          severity = vim.diagnostic.severity.WARN,
        }
      ),
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      callback = function() lint.try_lint() end,
    })
  end,
}
