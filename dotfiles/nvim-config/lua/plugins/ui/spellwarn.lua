---@module 'lazy'
---@type LazySpec
return {
  'ravibrock/spellwarn.nvim',
  -- WARN:
  -- it's triggering error on lazy loading
  -- on ft markdown and BufRead
  -- even though spell was set
  -- can use nvim -V1 to inspect the last set
  -- but for now I think I don't need it
  enabled = false,
  ft = 'markdown',
  config = function()
    require('spellwarn').setup {
      ft_default = false,
      ft_config = {
        markdown = true,
      },
    }
  end,
}
