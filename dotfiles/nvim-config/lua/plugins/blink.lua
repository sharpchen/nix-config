---@module 'lazy'
---@type LazySpec
return {
  'Saghen/blink.cmp',
  version = '*',
  build = IsWindows and ''
    or 'export CARGO_NET_GIT_FETCH_WITH_CLI=true; nix run .#build-plugin --accept-flake-config',
  event = 'BufReadPost',
  dependencies = {
    'moyiz/blink-emoji.nvim',
    {
      'xzbdmw/colorful-menu.nvim',
      lazy = true,
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
          roslyn = {
            extra_info_hl = '@comment',
          },
          basedpyright = {
            -- It is usually import path such as "os"
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
    keymap = {
      preset = 'super-tab',
      ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    enabled = function()
      return not vim.list_contains(
        { 'lazy', 'rip-substitute', 'DressingInput', 'typr' },
        vim.bo.filetype
      ) and vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
    end,
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      min_keyword_length = function(ctx)
        return ctx.trigger.kind == 'trigger_character' and 0 or 1
      end,
      default = function()
        local ok, node = pcall(vim.treesitter.get_node)
        if ok and node and node:type():find('comment') then return { 'buffer' } end
        return { 'snippets', 'lsp', 'path', 'buffer', 'emoji' }
      end,
      providers = {
        snippets = {
          min_keyword_length = 1,
          score_offset = 1,
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
            -- and not require('blink.cmp').snippet_active()
          end,
        },
        lsp = {
          score_offset = 3,
        },
        buffer = {
          -- min_keyword_length = 3,
          score_offset = 1,
        },
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
        emoji = {
          module = 'blink-emoji',
          name = 'Emoji',
          score_offset = 15,
          opts = { insert = true }, -- Insert emoji (default) or complete its name
          should_show_items = function()
            return vim.list_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype)
          end,
        },
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
      keyword = { range = 'full' },
      trigger = {
        show_on_trigger_character = true,
      },
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = {
          preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
          auto_insert = false,
        },
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
        border = 'none',
        draw = {
          columns = {
            { 'kind_icon', 'label', gap = 1 },
            -- { 'kind' },
            -- { 'source_name' },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return require('utils.const').lsp.completion_kind_icons[ctx.kind]
                  .. ctx.icon_gap
                  .. ' '
              end,
              highlight = function(ctx) return 'BlinkCmpKind' .. ctx.kind end,
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
    fuzzy = {
      sorts = { 'exact', 'score', 'sort_text' },
      implementation = IsWindows and 'lua' or 'rust',
    },
  },
}
