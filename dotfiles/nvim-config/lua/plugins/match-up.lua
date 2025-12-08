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
        enabled = 0,
        offscreen = {
          method = 'status_manual',
        },
      },
      motion = {
        keepjumps = true,
      },
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'xaml', 'msbuild', 'slnx', 'axaml' },
      callback = function() vim.b.match_words = vim.fn['matchup#util#standard_xml']() end,
    })
  end,
}
