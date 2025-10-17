---@diagnostic disable: missing-fields
---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local treesitter = require('nvim-treesitter')
      treesitter.setup {}
      local should_install = {
        'fsharp',
        'c_sharp',
        'vim',
        'c',
        'printf',
        'powershell',
        'nix',
        'xml',
        'css',
        'bash',
        'diff',
        'lua',
        'luap',
        'luadoc',
        'vim',
        'vimdoc',
        'typescript',
        'javascript',
        'jsdoc',
        'html',
        'http',
        'json',
        'jsonc',
        'sql',
        'python',
        'csv',
        'vue',
        'gitignore',
        'gitcommit',
        'gitattributes',
        'git_config',
        'go',
        'query',
        'toml',
        'yaml',
        'regex',
        'markdown',
        'markdown_inline',
      }

      treesitter.install(table.except(should_install, treesitter.get_installed()))

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if
            vim.g.colors_name == 'habamax'
            and vim.list_contains(
              { 'javascript', 'typescript', 'ps1', 'python' },
              args.match
            )
          then
            return
          end
          if
            vim.list_contains(
              treesitter.get_installed(),
              vim.treesitter.language.get_lang(args.match)
            )
          then
            vim.treesitter.start(args.buf)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
          include_surrounding_whitespace = true,
        },
        move = {
          set_jumps = false,
        },
      }
      do -- move
        vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
          require('nvim-treesitter-textobjects.move').goto_next_start(
            '@function.outer',
            'textobjects'
          )
          vim.cmd('normal! zz')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
          require('nvim-treesitter-textobjects.move').goto_previous_start(
            '@function.outer',
            'textobjects'
          )
          vim.cmd('normal! zz')
        end)
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false, -- Enable multiwindow support.
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
      vim.keymap.set(
        'n',
        '[c',
        function() require('treesitter-context').go_to_context(vim.v.count1) end
      )
    end,
  },
  {
    'tree-sitter-grammars/tree-sitter-test',
    -- compile on your own on Windows
    build = 'make parser/test.so',
    ft = 'test',
    init = function()
      -- toggle full-width rules for test separators
      vim.g.tstest_fullwidth_rules = false
      -- set the highlight group of the rules
      vim.g.tstest_rule_hlgroup = 'FoldColumn'
    end,
  },
  {
    'Wansmer/sibling-swap.nvim',
    config = function()
      local swap = require('sibling-swap')
      swap.setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '<leader>w', swap.swap_with_right_with_opp)
      vim.keymap.set('n', '<leader>q', swap.swap_with_left_with_opp)
    end,
  },
  {
    'Wansmer/treesj',
    config = function()
      require('treesj').setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', 'gJ', require('treesj').join)
      vim.keymap.set('n', 'gS', require('treesj').split)
      vim.keymap.set('n', '<leader>j', require('treesj').toggle)
    end,
  },
}
