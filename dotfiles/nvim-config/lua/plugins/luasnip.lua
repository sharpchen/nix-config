---@module 'lazy'
---@type LazySpec
return {
  'L3MON4D3/LuaSnip',
  -- branch = 'master',
  version = 'v2.*',
  dependencies = { 'rafamadriz/friendly-snippets' },
  build = 'make install_jsregexp',
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()

    local add = require('utils.static').snippet.add

    add(
      'lua',
      'keymap',
      "vim.keymap.set('<n>', <action>, { desc = '<desc>', noremap = true })"
    )
    add(
      'lua',
      'au',
      [[
      vim.api.nvim_create_autocmd('<event>', {
        callback = function (args)
          <-- body>
        end
      })
        ]]
    )
    add(
      'lua',
      'lazyspec',
      [[
    ---@module 'lazy'
    ---@type LazySpec
        ]]
    )
    -- add(
    --   { 'cs', 'typescript', 'javascript', 'lua', 'json' },
    --   'lambda',
    --   '([param]) => [/* body */]',
    --   { delimiters = '[]' }
    -- )
    add(
      'markdown',
      'details',
      [[
        <details>
        <summary>{summary}</summary>
        {content}
        </details>
        ]],
      { delimiters = '{}' }
    )

    -- local ok, ls = pcall(require, 'luasnip')
    -- if not ok then return end
    -- local snip = ls.snippet --[[@as fun(trigger: string, node: any[] | any)]]
    -- local oneof = ls.c --[[@as fun(idx: integer, choices: any[], opts: table)]]
    -- local text = ls.t --[[@as fun(text: string)]]
    -- local insert = ls.i --[[@as fun(idx: integer, placeholder: string)]]
    -- local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts: table)]]
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

    -- local add = function(filetype, trigger, body, opts)
    --   local ok, ls = pcall(require, 'luasnip')
    --   if not ok then return end
    --   local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
    --   local insert = ls.i --[[@as fun(idx: integer, placeholder: string)]]
    --   local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts: table)]]
    --
    --   opts = (opts and opts.delimiters) and opts or { delimiters = '<>' }
    --   local l, r = opts.delimiters:sub(1, 1), opts.delimiters:sub(2, 2)
    --   local placeholders = Collect(body:gmatch(l:verbatim() .. '(.-)' .. r:verbatim()))
    --   local body, count = body:gsub(l:verbatim() .. '.-' .. r:verbatim(), opts.delimiters)
    --   local nodes = {}
    --
    --   for i = 1, count do
    --     vim.notify(placeholders[i])
    --     table.insert(nodes, insert(i, placeholders[i]))
    --   end
    --
    --   vim.notify(vim.inspect(body))
    --   if type(filetype) == 'table' then
    --     for _, ft in ipairs(filetype) do
    --       ls.add_snippets(ft, {
    --         snip(trigger, fmt(body, nodes, opts)),
    --       })
    --     end
    --   else
    --     ls.add_snippets(filetype, {
    --       snip(trigger, fmt(body, nodes, opts)),
    --     })
    --   end
    --
    --   vim.notify(vim.inspect(placeholders))
    -- end
    --
    -- require('luasnip').add_snippets('all', {
    --   add(
    --     { 'cs', 'typescript', 'javascript', 'lua' },
    --     'lambda',
    --     '([param]) => [/* body */]',
    --     { delimiters = '[]' }
    --   ),
    -- }, { key = '043fd491-ba06-4133-a415-b858f1bf795e' })
  end,
}
