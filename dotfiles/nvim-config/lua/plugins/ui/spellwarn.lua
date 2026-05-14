---@module 'lazy'
---@type LazySpec
return {
  'ravibrock/spellwarn.nvim',
  event = 'BufRead *.md',
  config = function()
    require('spellwarn').setup {
      ft_default = false,
      ft_config = {
        markdown = true,
      },
    }
  end,
}
