return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup({
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
    })

    local function format(bufnr)
      local conform = require('conform')
      local formatter = conform.formatters[vim.bo.filetype] or conform.formatters_by_ft[vim.bo.filetype]
      if formatter then
        conform.format({ bufnr = bufnr, timeout_ms = 2000, async = false })
        vim.notify(
          string.format(
            'formmatted by formatter: %s',
            type(formatter) == 'function' and formatter(bufnr)[1] or formatter[1]
          )
        )
      else
        local clients = vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):filter(function(client)
          return not not client.server_capabilities.documentFormattingProvider
        end)

        if #clients:totable() == 0 then
          return
        end

        vim.lsp.buf.format({ async = false, timeout_ms = 2000, bufnr = bufnr })
        local names = clients
          :map(function(client)
            return client.name
          end)
          :totable()
        vim.notify(string.format('formmatted by lsp: %s', table.concat(names, ',')))
      end
    end

    local augroup_id = vim.api.nvim_create_augroup('format_on_save', { clear = true })
    local function add_format_event()
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup_id,
        callback = function(event)
          format(event.buf)
        end,
        desc = 'format on save',
      })
    end

    vim.api.nvim_create_user_command('W', function()
      if vim.fn.exists(':W') == 1 then
        vim.cmd('delcommand W')
      end
      vim.api.nvim_clear_autocmds({ group = augroup_id })
      vim.cmd('w')
      add_format_event()
    end, { desc = 'save without format' })

    add_format_event()

    vim.keymap.set('n', '<leader>k', function()
      format(vim.fn.bufnr('%'))
    end, { desc = 'format current file' })
  end,
}
