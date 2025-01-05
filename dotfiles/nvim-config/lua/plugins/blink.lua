return {
  'saghen/blink.cmp',
  version = '*',
  build = 'export CARGO_NET_GIT_FETCH_WITH_CLI=true; nix run .#build-plugin',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      build = 'make install_jsregexp',
    },
    'rafamadriz/friendly-snippets',
    'xzbdmw/colorful-menu.nvim',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'super-tab' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    enabled = function()
      return not vim.list_contains({ 'lazy', 'rip-substitute' }, vim.bo.filetype)
        and vim.bo.buftype ~= 'prompt'
        and vim.b.completion ~= false
    end,
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = function()
        local ok, node = pcall(vim.treesitter.get_node)
        if ok and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          return { 'buffer' }
        end
        return { 'lsp', 'path', 'snippets', 'buffer', 'luasnip' }
      end,
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
        -- lazydev = {
        --   name = 'LazyDev',
        --   module = 'lazydev.integrations.blink',
        --   score_offset = 100,
        -- },
      },
    },
    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    signature = {
      enabled = true,
      window = { border = 'solid' },
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = 'preselect',
      },
      documentation = {
        auto_show = true,
        window = {
          border = 'solid',
        },
      },
      menu = {
        border = 'solid',
        draw = {
          columns = {
            { 'kind_icon', 'label', gap = 1 },
            { 'kind' },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return require('utils.const').lsp.completion_kind_icons[ctx.kind] .. ctx.icon_gap .. ' '
              end,
              highlight = function(ctx)
                return 'BlinkCmpKind' .. ctx.kind
              end,
            },
            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                local highlights_info = require('colorful-menu').highlights(ctx.item, vim.bo.filetype)
                return highlights_info ~= nil and highlights_info.text or ctx.label
              end,
              highlight = function(ctx)
                local highlights_info = require('colorful-menu').highlights(ctx.item, vim.bo.filetype)
                local highlights = {}
                if highlights_info ~= nil then
                  for _, info in ipairs(highlights_info.highlights) do
                    table.insert(highlights, {
                      info.range[1],
                      info.range[2],
                      group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or info[1],
                    })
                  end
                end
                for _, idx in ipairs(ctx.label_matched_indices) do
                  table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                end
                return highlights
              end,
            },
          },
        },
      },
    },
  },
}
