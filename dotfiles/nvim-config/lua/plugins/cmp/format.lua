require('cmp').setup.global({
  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, item)
      local entryItem = entry.completion_item
      local color = entryItem.documentation --[[@as string]]
      local completion_item = entry.completion_item
      local highlights_info = require('colorful-menu').highlights(completion_item, vim.bo.filetype)

      -- error, such as missing parser, fallback to use raw label.
      if highlights_info == nil then
        item.abbr = completion_item.label
      else
        item.abbr_hl_group = highlights_info.highlights
        item.abbr = highlights_info.text
      end
      if color and type(color) == 'string' and color:match('^#%x%x%x%x%x%x$') then
        -- check if color is hexcolor
        local hl = 'hex-' .. color:sub(2)
        if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
          vim.api.nvim_set_hl(0, hl, { fg = color })
        end
        item.menu = ' '
        item.menu_hl_group = hl
      else
        local kind_name = item.kind --[[@as string]]
        item.kind = require('utils.const').lsp.completion_kind_icons[item.kind] .. ' '
        item.menu = ('%s %s'):format(require('utils.text').case.convert(kind_name, 'camel'), ({
          buffer = '[buf]',
          nvim_lsp = '[lsp]',
          luasnip = '[luasnip]',
          nvim_lua = '[lua]',
          spell = '[spell]',
          path = '[path]',
          latex_symbols = '[LaTeX]',
          dictionary = '[dict]',
          ['vim-dadbod-completion'] = '[db]',
        })[entry.source.name] or string.empty)
      end
      return item
    end,
  },
})
