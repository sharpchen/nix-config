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
  {
    'echasnovski/mini.ai',
    version = false,
    config = function()
      local ts_spec = require('mini.ai').gen_spec.treesitter
      require('mini.ai').setup {
        custom_textobjects = {
          f = ts_spec { a = '@function.outer', i = '@function.inner' },
          c = ts_spec { a = '@class.outer', i = '@class.inner' },
          C = ts_spec { a = '@comment.outer', i = '@comment.outer' },
          o = ts_spec {
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          },
          p = ts_spec {
            a = '@parameter.outer',
            i = '@parameter.inner',
          },
          S = ts_spec {
            a = '@string.outer',
            i = '@string.inner',
          },
        },
        mappings = {
          goto_left = '',
          goto_right = '',
        },
        search_method = 'cover_or_next',
      }
    end,
  },
  {
    'bkoropoff/clipipe',
    enabled = IsWindows,
    config = function()
      require('clipipe').setup {
        keep_line_endings = false, -- Set to true to disable \r\n conversion on Windows
        download = false, -- Download pre-built binary if needed
        build = true, -- Build from source if needed
      }
    end,
  },
}
