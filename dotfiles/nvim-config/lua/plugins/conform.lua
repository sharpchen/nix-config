return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  config = function()
    local conform = require('conform')
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
          args = { '.' },
        },
      },
      formatters_by_ft = {
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        json = { 'jq' },
        lua = { 'stylua' },
        javascript = { 'oxfmt', 'prettier' },
        typescript = { 'oxfmt', 'prettier' },
        html = { 'oxfmt', 'prettier' },
        css = { 'oxfmt', 'prettier' },
        vue = { 'oxfmt', 'prettier' },
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

    vim.keymap.set(
      'n',
      '<leader>k',
      function()
        conform.format {
          bufnr = 0,
          timeout_ms = 5000,
          async = false,
          lsp_format = 'fallback',
        }
      end,
      { desc = 'format current file' }
    )
  end,
}
