return {
  'L3MON4D3/LuaSnip',
  dependencies = { 'rafamadriz/friendly-snippets' },
  build = 'make install_jsregexp',
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()

    local add = require('utils.static').snippet.add

    add('lua', 'keymap', "vim.keymap.set('<mode>', <action>, { desc = '<desc>' })")
    add(
      'lua',
      'au',
      [[vim.api.nvim_create_autocmd('<event>', {
      callback = function (args)
        <-- body>
      end
      })]]
    )
    add(
      'lua',
      'lazyspec',
      [[
---@module 'lazy'
---@type LazySpec
    ]]
    )
    add(
      { 'cs', 'typescript', 'javascript', 'lua', 'json' },
      'lambda',
      '([param]) => [/* body */]',
      { delimiters = '[]' }
    )

    local ok, ls = pcall(require, 'luasnip')
    if not ok then return end
    local snip = ls.snippet --[[@as fun(trigger: string, node: any[] | any)]]
    local oneof = ls.c --[[@as fun(idx: integer, choices: any[], opts: table)]]
    local text = ls.t --[[@as fun(text: string)]]
    local insert = ls.i --[[@as fun(idx: integer, placeholder: string)]]
    local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts: table)]]
    -- ls.add_snippets('cs', {
    --   snip(
    --     'lambda',
    --     fmt(
    --       '([]) => []',
    --       { insert(1, 'param'), insert(2, '/* body */') },
    --       { delimiters = '[]' }
    --     )
    --   ),
    -- })
  end,
}
