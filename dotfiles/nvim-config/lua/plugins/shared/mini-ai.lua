---@module 'lazy'
---@type LazySpec
return {
  'echasnovski/mini.ai',
  version = false,
  event = { 'BufReadPost', 'BufNewFile' },
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
}
