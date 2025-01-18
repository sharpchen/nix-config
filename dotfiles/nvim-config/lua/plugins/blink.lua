return {
  'Saghen/blink.cmp',
  version = '*',
  build = 'export CARGO_NET_GIT_FETCH_WITH_CLI=true; nix run .#build-plugin --accept-flake-config',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      build = 'make install_jsregexp',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    'rafamadriz/friendly-snippets',
    {
      'xzbdmw/colorful-menu.nvim',
      opts = {
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
      },
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'super-tab' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    enabled = function()
      return not vim.list_contains({ 'lazy', 'rip-substitute', 'DressingInput' }, vim.bo.filetype)
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
        return { 'snippets', 'lsp', 'path', 'buffer' }
      end,
      providers = {
        snippets = {
          min_keyword_length = 2,
          score_offset = 3,
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
        lsp = {
          min_keyword_length = 1,
          score_offset = 3,
        },
        -- path = {
        --   min_keyword_length = 3,
        --   score_offset = 2,
        -- },
        buffer = {
          min_keyword_length = 3,
          score_offset = 1,
        },
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
        -- cmdline = {
        --   enabled = function()
        --     return vim.fn.getcmdline():sub(1, 1) ~= '!'
        --   end,
        -- },
        -- lazydev = {
        --   name = 'LazyDev',
        --   module = 'lazydev.integrations.blink',
        --   score_offset = 100,
        -- },
      },
    },
    snippets = {
      preset = 'luasnip',
    },
    signature = {
      enabled = true,
      window = { border = 'single' },
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      documentation = {
        auto_show = true,
        window = {
          border = 'single',
        },
      },
      accept = {
        auto_brackets = {
          enabled = true,
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { 'ps1', 'sh' },
          },
        },
      },
      menu = {
        border = 'single',
        draw = {
          columns = {
            { 'kind_icon', 'label', gap = 1 },
            { 'kind' },
            { 'source_name' },
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
                return require('colorful-menu').blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require('colorful-menu').blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
  },
}
