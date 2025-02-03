local function setup()
  local light = require('Eva-Theme.palette').light_base
  local dark = require('Eva-Theme.palette').dark_base
  require('Eva-Theme').setup({
    override_palette = {
      dark = {
        -- operator = dark.punctuation,
        -- background = '#14161B',
        typeparam = dark.primitive,
      },
      light = {
        -- operator = light.punctuation,
        typeparam = light.primitive,
      },
    },
    override_highlight = {
      ['@lsp.type.enumMember'] = function(v)
        return {
          fg = require('Eva-Theme.utils').is_dark(v) and require('Eva-Theme.palette').dark_base.digit
            or require('Eva-Theme.palette').light_base.digit,
          bold = true,
        }
      end,
      LspInlayHint = function(_, p)
        return {
          fg = p.comment,
          bg = nil,
        }
      end,
      CursorLine = function(_, p)
        return { bg = p.panelBackground }
      end,
      ['@string.escape'] = function(_, _)
        return { bold = true }
      end,
      ['@punctuation.special'] = function(_, _)
        return { bold = true }
      end,
    },
  })
end

return os.getenv('eva') == nil
    and {
      'sharpchen/Eva-Theme.nvim',
      lazy = false,
      priority = 1000,
      build = ':EvaCompile',
      config = setup,
    }
  or {
    dir = '~/projects/Eva-Theme.nvim',
    lazy = false,
    priority = 1000,
    build = ':EvaCompile',
    config = setup,
  }
