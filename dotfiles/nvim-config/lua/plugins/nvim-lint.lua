return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      -- typescript = { 'eslint' },
      javascript = { 'eslint' },
      -- markdown = { 'markdownlint-cli2' },
      sql = { 'sqlfluff' },
      plsql = { 'sqlfluff' },
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged', 'TextChangedI' }, {
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
