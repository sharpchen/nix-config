return {
  'ibhagwan/fzf-lua',
  config = function()
    local fzf = require('fzf-lua')
    fzf.setup({})

    vim.keymap.set('n', '<leader>fc', function()
      local config_path = require('utils.env').is_windows and vim.fn.stdpath('config')
        or '~/.config/home-manager/dotfiles/nvim-config/'
      fzf.files({
        cwd = config_path,
      })
    end, { desc = 'find nvim config file' })

    vim.keymap.set('n', '<leader>fg', fzf.live_grep_resume, { desc = 'grep from files' })
    vim.keymap.set('n', '<leader>fpf', fzf.git_files, { desc = 'find in all tracked files' })
    vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'help tags' })
    vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'find files' })
    vim.keymap.set('n', '<leader>ca', fzf.lsp_code_actions, { noremap = true, silent = true, desc = 'code actions' })
    vim.keymap.set('n', '<leader>fe', fzf.diagnostics_document, { desc = 'document diagnostics' })
    vim.keymap.set('n', '<leader>fr', function()
      vim.cmd(('Oil %s'):format(vim.uv.cwd()))
    end, { desc = 'root folder' })
  end,
}
