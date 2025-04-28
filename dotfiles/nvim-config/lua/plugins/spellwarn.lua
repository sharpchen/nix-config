return {
  'ravibrock/spellwarn.nvim',
  event = 'VeryLazy',
  config = function()
    require('spellwarn').setup {
      ft_default = false,
      ft_config = {
        markdown = true,
      },
    }
  end,
}
