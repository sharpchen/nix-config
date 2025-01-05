return {
  'Wansmer/symbol-usage.nvim',
  event = 'LspAttach', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local function h(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end
    vim.api.nvim_set_hl(0, 'SymbolUsageText', { fg = h('Comment').fg, italic = false })
    local function text_format(symbol)
      local fragments = {}
      -- Indicator that shows if there are any other symbols in the same line
      local stacked_functions = symbol.stacked_count > 0 and (' | +%s'):format(symbol.stacked_count) or ''
      if symbol.references then
        local reference = symbol.references <= 1 and 'reference' or 'references'
        local num = symbol.references == 0 and 'no' or symbol.references
        table.insert(fragments, ('▸ %s %s'):format(num, reference))
      end
      if symbol.definition then
        table.insert(fragments, '▸ ' .. symbol.definition .. ' definition')
      end
      if symbol.implementation then
        table.insert(fragments, '▸ ' .. symbol.implementation .. ' implementation')
      end
      return table.concat(fragments, ', ') .. stacked_functions
    end
    require('symbol-usage').setup({
      text_format = text_format,
      vt_position = 'end_of_line',
      implementation = { enabled = true },
    })
  end,
}
