return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
      },
    },
    enabled = function()
      return not vim.uv.fs_stat(vim.uv.cwd() .. '/.luarc.json')
    end,
  },
  { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  { 'justinsgithub/wezterm-types', lazy = true },
}
