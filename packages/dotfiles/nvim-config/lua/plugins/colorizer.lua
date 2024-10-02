return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    local foo = '#ca8aca'
    require('colorizer').setup({
      filetypes = {
        '*',
        '!lazy',
        '!cmp_menu',
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
    })
  end,
}
