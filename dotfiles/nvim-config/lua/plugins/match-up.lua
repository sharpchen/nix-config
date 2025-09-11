---@diagnostic disable: missing-fields
---@module 'lazy'
---@type LazySpec
return {
  'andymass/vim-matchup',
  lazy = false,
  init = function()
    require('match-up').setup {
      treesitter = {
        stopline = 500,
      },
      matchparen = {
        offscreen = {
          method = 'status_manual',
        },
      },
      motion = {
        keepjumps = true,
      },
    }
  end,
}
