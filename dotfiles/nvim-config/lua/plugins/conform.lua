return {
  'stevearc/conform.nvim',
  event = 'BufReadPost',
  config = function()
    require('conform').setup {
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
        json = { 'jq' },
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
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

    local function format(bufnr)
      local conform = require('conform')
      local ft = vim.bo[bufnr].filetype
      local formatter = conform.formatters[ft] or conform.formatters_by_ft[ft]

      if ft == 'markdown' then
        vim.notify(string.format('no formatter available for %s', ft))
        return
      end

      if ft == 'oil' then return end

      local ok = formatter
        and conform.format { bufnr = bufnr, timeout_ms = 5000, async = false }
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
          vim.api.nvim_feedkeys('mzgg=G`z', 'tx', false)
          vim.notify('formatted by indent option')
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

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('format_on_save', { clear = true }),
      callback = function(event) format(event.buf) end,
      desc = 'format on save',
    })

    vim.keymap.set(
      'n',
      '<leader>k',
      function() format(vim.fn.bufnr('%')) end,
      { desc = 'format current file' }
    )
  end,
}
