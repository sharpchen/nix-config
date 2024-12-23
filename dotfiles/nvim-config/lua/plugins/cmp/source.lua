require('cmp').setup.global({
  sources = {
    {
      name = 'nvim_lsp',
      entry_filter = function(entry, ctx)
        -- Check if the buffer type is 'vue'
        if ctx.filetype ~= 'vue' then
          return true
        end
        local cursor_before_line = ctx.cursor_before_line
        -- For events
        if cursor_before_line:sub(-1) == '@' then
          return entry.completion_item.label:match('^@')
          -- For props also exclude events with `:on-` prefix
        elseif cursor_before_line:sub(-1) == ':' then
          return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on%-')
        else
          return true
        end
      end,
    },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
    {
      name = 'dictionary',
      keyword_length = 2,
    },
    {
      name = 'spell',
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
        preselect_correct_word = true,
      },
    },
  },
})
