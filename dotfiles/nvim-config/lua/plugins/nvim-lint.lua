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
      parser = function(out)
        return vim
          .iter(vim.split(out, '\n'))
          :filter(
            function(line) return not line:match('^=+') and not line:match('^%s*$') end
          )
          :map(function(line)
            local lnum, col, code, msg =
              line:match('%(%d+,%d+,(%d+),(%d+)%):FSharpLint warning (.-): (.+)$')
            ---@type vim.Diagnostic
            return {
              lnum = tonumber(lnum) - 1,
              col = tonumber(col) - 1,
              message = msg,
              severity = vim.diagnostic.severity.WARN,
              source = 'fsharplint',
              code = code,
            }
          end)
          :totable()
      end,
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      callback = function() lint.try_lint() end,
    })
  end,
}
