---@module 'lazy'
---@type LazySpec
return {
  {
    'axelvc/template-string.nvim',
    ft = {
      'cs',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'svelte',
      'html',
    },
    -- enabled = false,
    config = function()
      require('template-string').setup {
        remove_template_string = true,
      }
    end,
  },
  {
    'chaoren/vim-wordmotion',
    event = 'BufReadPost',
    init = function()
      vim.g.wordmotion_nomap = 0
      ---@type boolean my indicator for word motion
      vim.g.wordmotion_enabled = true
    end,
    config = function()
      vim.api.nvim_create_user_command('WordMotionToggle', function()
        if vim.g.loaded_wordmotion == 1 and vim.g.wordmotion_nomap == 0 then
          for key, _ in pairs(vim.g.wordmotion_mappings or {}) do
            vim.g.wordmotion_mappings[key] = '' -- disable custom mappings
          end
          vim.g.loaded_wordmotion = nil
          vim.g.wordmotion_nomap = 1
          vim.cmd('runtime plugin/wordmotion.vim')
          vim.g.wordmotion_enabled = false
        else
          vim.g.wordmotion_nomap = 0
          vim.cmd('runtime plugin/wordmotion.vim')
          vim.g.wordmotion_enabled = true
        end
      end, { desc = 'toggle wordmotion' })
    end,
  },
  {
    'sharpchen/contextindent.nvim',
    branch = 'cindent',
    opts = { pattern = '*.md' },
  },
  {
    'machakann/vim-sandwich',
    event = 'BufReadPost',
  },
}
