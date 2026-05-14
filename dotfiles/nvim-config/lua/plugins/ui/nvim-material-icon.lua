---@module 'lazy'
---@type LazySpec
return {
  'DaikyXendo/nvim-material-icon',
  -- 'sharpchen/nvim-material-icon',
  -- branch = 'rm-invalid-icon',
  event = 'VeryLazy',
  config = function()
    require('nvim-web-devicons').set_icon_by_filetype {
      msbuild = 'sln',
      axaml = 'xaml',
      typescript = 'ts',
      javascript = 'js',
      python = 'py',
    }
  end,
}
