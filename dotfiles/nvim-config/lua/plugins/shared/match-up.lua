---@diagnostic disable: missing-fields
---@module 'lazy'
---@type LazySpec
return {
  'andymass/vim-matchup',
  -- NOTE: remove lazy-loading if anything goes wrong
  event = 'BufRead',
  lazy = false,
  config = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require('match-up').setup {
      treesitter = {
        stopline = 500,
        disable_virtual_text = true,
      },
      matchparen = {
        -- enabled = 0,
        offscreen = {
          method = 'status_manual',
        },
      },
      motion = {
        keepjumps = true,
      },
    }

    -- this requires non-lazy loading
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function(ctx) vim.api.nvim_set_hl(0, 'MatchWord', {}) end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'xaml', 'msbuild', 'slnx', 'axaml' },
      callback = function() vim.b.match_words = vim.fn['matchup#util#standard_xml']() end,
    })
  end,
}
