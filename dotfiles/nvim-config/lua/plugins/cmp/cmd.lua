local cmp = require('cmp')

local keymap = {
  ['<Tab>'] = cmp.mapping.confirm({ select = false }),
  ['<C-Down>'] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  ['<C-Up>'] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
}

-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(keymap),
--   sources = {
--     { name = 'buffer' },
--     {
--       name = 'spell',
--       option = {
--         keep_all_entries = false,
--         enable_in_context = function()
--           return true
--         end,
--         preselect_correct_word = true,
--       },
--     },
--   },
-- })

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(keymap),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' },
      },
    },
  }),
})
