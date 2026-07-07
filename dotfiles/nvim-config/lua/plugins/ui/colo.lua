local function setup()
  require('Eva-Theme').setup {
    override_palette = {
      dark = function(palette)
        ---@type Eva-Theme.Palette
        return {
          typeparam = palette.dark_base.primitive,
        }
      end,
      light = function(palette)
        ---@type Eva-Theme.Palette
        return {
          typeparam = palette.light_base.primitive,
        }
      end,
    },
    override_highlight = function(v, p)
      ---@type table<string, vim.api.keyset.highlight>
      local hl = {
        ['@lsp.type.enumMember'] = {
          fg = v:match('dark') and p.dark_base.digit or p.light_base.digit,
          bold = true,
        },
        LspInlayHint = { fg = p.current.comment, bg = 'none' },
        CursorLine = { bg = p.current.panelBackground },
        ['@string.escape'] = { bold = true },
        ['@punctuation.special'] = { bold = true },
        ['@punctuation.special.typescript'] = { bold = true },
        ['@keyword.operator'] = { fg = p.current.declarative },
        ['@keyword.coroutine'] = { fg = p.current.declarative },
        SymbolUsageText = { fg = p.current.comment, italic = false },
        SnacksPickerMatch = { fg = p.current.property, bold = true },
        StatusLine = { bg = p.current.variable, fg = p.current.panelBackground },
        StatusLineNC = { bg = p.current.comment, fg = p.current.panelBackground },
        ['@lsp.type.keyword.lua'] = {},
      }

      return vim.tbl_extend(
        'error',
        vim.iter({ 'Error', 'Warn', 'Hint', 'Info' }):fold({}, function(final, curr)
          final['DiagnosticVirtualText' .. curr] = { bg = 'none' }
          return final
        end),
        hl
      )
    end,
  }
end

---@module 'lazy'
---@type LazySpec
return {
  os.getenv('eva') == nil and {
    'sharpchen/Eva-Theme.nvim',
    lazy = false,
    priority = 1000,
    config = setup,
  } or {
    dir = '~/projects/Eva-Theme.nvim',
    lazy = false,
    priority = 1000,
    config = setup,
  },
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      group_overrides = {
        StatusLine = { bg = '#007acc', fg = 'white' },
      },
    },
  },
  {
    'habamax/vim-habamax',
    lazy = false,
    priority = 1000,
  },
}
