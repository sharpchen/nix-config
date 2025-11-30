---@module 'lazy'
---@type LazySpec
return {
  'catgoose/nvim-colorizer.lua',
  event = 'VeryLazy',
  config = function()
    require('colorizer').setup {
      filetypes = {
        '*',
        '!lazy',
        '!cmp_menu',
        css = { names = true },
        html = { names = true },
      },
      user_default_options = {
        names = false,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = 'virtualtext',
        virtualtext = '●',
        virtualtext_inline = true,
        tailwind = 'both',
        always_update = true,
      },
    }
  end,
}
