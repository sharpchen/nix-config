return {
  'Wansmer/symbol-usage.nvim',
  event = 'BufReadPre', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    --[[ vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
        vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
        vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
        vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
        vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })
      end,
    }) ]]
    local function text_format(symbol)
      local fragments = {}
      -- Indicator that shows if there are any other symbols in the same line
      local stacked_functions = symbol.stacked_count > 0 and (' | +%s'):format(symbol.stacked_count) or ''
      if symbol.references then
        local usage = symbol.references <= 1 and 'usage' or 'usages'
        local num = symbol.references == 0 and 'no' or symbol.references
        table.insert(fragments, ('%s %s'):format(num, usage))
      end
      if symbol.definition then
        table.insert(fragments, symbol.definition .. ' definitions')
      end
      if symbol.implementation then
        table.insert(fragments, symbol.implementation .. ' implementations')
      end
      return table.concat(fragments, ', ') .. stacked_functions
    end
    require('symbol-usage').setup({
      text_format = text_format,
    })
  end,
}
