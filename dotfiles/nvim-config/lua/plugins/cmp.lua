local function setup_cmd()
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
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(keymap),
    sources = {
      { name = 'buffer' },
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
  -- `:` cmdline setup.
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
end

local function regular_setup()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  cmp.setup({
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
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
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
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    preselect = 'item',
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = false })
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, item)
        local entryItem = entry:get_completion_item()
        local color = entryItem.documentation
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
          item.menu = ('%s %s'):format(({
            buffer = '[buf]',
            nvim_lsp = '[lsp]',
            luasnip = '[luasnip]',
            nvim_lua = '[lua]',
            latex_symbols = '[LaTeX]',
            ['vim-dadbod-completion'] = '[db]',
          })[entry.source.name] or string.empty, kind_name:lower())
        end
        return item
      end,
    },
    sorting = {
      comparators = {
        cmp.config.compare.exact,
        ---prevent Text kind always on top
        function(x, y)
          local kinds = require('cmp.types.lsp').CompletionItemKind
          if x:get_kind() ~= kinds.Text and y:get_kind() == kinds.Text then
            return true
          end
          if x:get_kind() == kinds.Text and y:get_kind() ~= kinds.Text then
            return false
          end
          return cmp.config.compare.recently_used(x, y)
        end,
        ---prefer Snippet
        function(x, y)
          local kinds = require('cmp.types.lsp').CompletionItemKind
          if x:get_kind() == kinds.Snippet and y:get_kind() ~= kinds.Snippet then
            return true
          end
          if x:get_kind() ~= kinds.Snippet and y:get_kind() == kinds.Snippet then
            return false
          end
          return nil
        end,
        cmp.config.compare.length,
        cmp.config.compare.offset,
        cmp.config.compare.score,
        cmp.config.compare.kind,
      },
    },
    experimental = {
      ghost_text = false,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = false,
    },
  })
end

return {
  --[[ 'hrsh7th/nvim-cmp',
  branch = 'main', ]]
  'yioneko/nvim-cmp',
  branch = 'perf',
  event = { 'BufReadPre', 'BufNewFile' },
  version = false,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
    'hrsh7th/cmp-nvim-lua',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    {
      'L3MON4D3/LuaSnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      build = 'make install_jsregexp',
    },
  },
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
    regular_setup()
    setup_cmd()
    require('cmp').setup.filetype('rip-substitute', {
      enabled = false,
    })
  end,
}
