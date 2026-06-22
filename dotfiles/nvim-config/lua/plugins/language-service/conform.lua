return {
  'stevearc/conform.nvim',
  event = { 'BufRead' },
  cmd = { 'ConformInfo' },
  config = function()
    local conform = require('conform')
    ---@diagnostic disable-next-line: param-type-mismatch
    conform.setup {
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = 'fallback',
        timeout_ms = 5000,
      },
      formatters = {
        xstyler = {
          command = 'xstyler',
          args = { '--write-to-stdout', '--take-pipe' },
        },
        jq = {
          command = 'jq',
          stdin = true,
          args = function(_, ctx) return { '--indent', ctx.shiftwidth, '.' } end,
        },
        shfmt = {
          inherit = true,
          prepend_args = { '--binary-next-line' },
        },
      },
      formatters_by_ft = {
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        json = { 'jq' },
        lua = { 'stylua' },
        -- NOTE: using oxfmt in-process lsp is faster
        -- javascript = { 'oxfmt', 'prettier', stop_after_first = true },
        -- typescript = { 'oxfmt', 'prettier' },
        -- html = { 'oxfmt', 'prettier', stop_after_first = true },
        -- css = { 'oxfmt', 'prettier', stop_after_first = true },
        -- vue = { 'oxfmt', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        yaml = { 'yamlfmt' },
        sql = { 'sqlfluff' },
        plsql = { 'sqlfluff' },
        nix = { 'nixfmt' },
        xaml = { 'xstyler' },
        axaml = { 'xstyler' },
        python = {
          -- To fix auto-fixable lint errors.
          'ruff_fix',
          -- To run the Ruff formatter.
          'ruff_format',
          -- To organize the imports.
          'ruff_organize_imports',
        },
      },
    }

    vim.keymap.set('n', '<leader>k', function()
      ---@diagnostic disable-next-line: param-type-mismatch
      conform.format {
        bufnr = 0,
        timeout_ms = 5000,
        async = false,
        lsp_format = 'fallback',
      }
    end, { desc = 'format current file' })
  end,
}
