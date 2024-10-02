return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        -- Use a sub-list to run only the first available formatter
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        sh = { 'shfmt' },
      },
    })

    local function format(bufnr)
      local conform = require('conform')
      local formatter = conform.formatters[vim.bo.filetype] or conform.formatters_by_ft[vim.bo.filetype]
      if formatter then
        conform.format({ bufnr = bufnr, timeout_ms = 2000, async = false })
        vim.notify(
          string.format('formmatted by formatter: %s', type(formatter) == 'function' and formatter()[1] or formatter[1])
        )
      else
        vim.lsp.buf.format({ async = false, timeout_ms = 2000, bufnr = bufnr })
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          table.insert(names, server.name)
        end
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
