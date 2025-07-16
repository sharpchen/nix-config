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
            vim.list_contains(
              treesitter.get_installed(),
              vim.treesitter.language.get_lang(args.match)
            )
          then
            -- vim.treesitter.start()
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
      do -- select
        vim.keymap.set(
          { 'x', 'o' },
          'af',
          function()
            require('nvim-treesitter-textobjects.select').select_textobject(
              '@function.outer',
              'textobjects'
            )
          end
        )
        vim.keymap.set(
          { 'x', 'o' },
          'if',
          function()
            require('nvim-treesitter-textobjects.select').select_textobject(
              '@function.inner',
              'textobjects'
            )
          end
        )
        vim.keymap.set(
          { 'x', 'o' },
          'ac',
          function()
            require('nvim-treesitter-textobjects.select').select_textobject(
              '@class.outer',
              'textobjects'
            )
          end
        )
        vim.keymap.set(
          { 'x', 'o' },
          'ic',
          function()
            require('nvim-treesitter-textobjects.select').select_textobject(
              '@class.inner',
              'textobjects'
            )
          end
        )
        vim.keymap.set(
          { 'x', 'o' },
          'as',
          function()
            require('nvim-treesitter-textobjects.select').select_textobject(
              '@local.scope',
              'locals'
            )
          end
        )
      end
      do -- swap
        vim.keymap.set(
          'n',
          '<leader>w',
          function()
            require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
          end
        )
        vim.keymap.set(
          'n',
          '<leader>W',
          function()
            require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
          end
        )
      end
      do -- move
        vim.keymap.set(
          { 'n', 'x', 'o' },
          ']]',
          function()
            require('nvim-treesitter-textobjects.move').goto_next_start(
              '@function.outer',
              'textobjects'
            )
          end
        )
        vim.keymap.set(
          { 'n', 'x', 'o' },
          '[[',
          function()
            require('nvim-treesitter-textobjects.move').goto_previous_start(
              '@function.outer',
              'textobjects'
            )
          end
        )
      end
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
}
