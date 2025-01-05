require('colorful-menu').setup({
  ls = {
    lua_ls = {
      -- Maybe you want to dim arguments a bit.
      auguments_hl = '@variable.parameter',
    },
    ts_ls = {
      extra_info_hl = '@comment',
    },
    vtsls = {
      extra_info_hl = '@comment',
    },
    ['rust-analyzer'] = {
      -- Such as (as Iterator), (use std::io).
      extra_info_hl = '@comment',
    },
    clangd = {
      -- Such as "From <stdio.h>".
      extra_info_hl = '@comment',
    },
  },
  -- If the built-in logic fails to find a suitable highlight group,
  -- this highlight is applied to the label.
  fallback_highlight = '@variable',
  -- If provided, the plugin truncates the final displayed text to
  -- this width (measured in display cells). Any highlights that extend
  -- beyond the truncation point are ignored. Default 60.
  max_width = 60,
})
