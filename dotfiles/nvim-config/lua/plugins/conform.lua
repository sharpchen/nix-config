return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        sh = { 'shfmt' },
        yaml = { 'yamlfmt' },
        sql = { 'sqlfluff' },
        plsql = { 'sqlfluff' },
        nix = { 'nixfmt' },
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

    local function format(bufnr)
      local conform = require('conform')
      local formatter = conform.formatters[vim.bo.filetype]
        or conform.formatters_by_ft[vim.bo.filetype]
      local ok = conform.format { bufnr = bufnr, timeout_ms = 5000, async = false }
      if ok then
        vim.notify(
          string.format(
            'formatted by: %s',
            type(formatter) == 'function' and formatter(bufnr)[1] or formatter[1]
          )
        )
      else
        local lsp_methods = require('vim.lsp.protocol').Methods
        local fmt_available = vim.lsp.get_clients {
          bufnr = bufnr,
          method = lsp_methods.textDocument_formatting,
        }

        if #fmt_available == 0 then
          if vim.bo[bufnr].filetype == 'markdown' then
            vim.notify(
              string.format('no formatter available for %s', vim.bo[bufnr].filetype)
            )
            return
          end
          vim.api.nvim_feedkeys('mzgg=G`z', 'tx', false)
          vim.notify('formatted by indentexpr')
        else
          vim.lsp.buf.format { async = false, timeout_ms = 5000, bufnr = bufnr }
          local names = vim.tbl_map(
            function(client) return client.name end,
            fmt_available
          )
          vim.notify(string.format('formatted by: %s', table.concat(names, ',')))
        end
      end
    end

    local augroup_id = vim.api.nvim_create_augroup('format_on_save', { clear = true })
    local function add_format_event()
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup_id,
        callback = function(event) format(event.buf) end,
        desc = 'format on save',
      })
    end

    vim.api.nvim_create_user_command('W', function()
      if vim.fn.exists(':W') == 1 then vim.cmd('delcommand W') end
      vim.api.nvim_clear_autocmds { group = augroup_id }
      vim.cmd('w')
      add_format_event()
    end, { desc = 'save without format' })

    add_format_event()

    vim.keymap.set(
      'n',
      '<leader>k',
      function() format(vim.fn.bufnr('%')) end,
      { desc = 'format current file' }
    )
  end,
}
