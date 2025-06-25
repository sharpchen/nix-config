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
            vim.treesitter.start()
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
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ['ic'] = {
              query = '@class.inner',
              desc = 'Select inner part of a class region',
            },
            -- You can also use captures from other query groups like `locals.scm`
            ['as'] = {
              query = '@scope',
              query_group = 'locals',
              desc = 'Select language scope',
            },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = 'V', -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']]'] = '@function.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']['] = '@function.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[['] = '@function.outer',
          },
          goto_previous_end = {
            ['[f'] = '@function.outer',
            ['[]'] = '@function.outer',
          },
        },
      }
    end,
  },
}
