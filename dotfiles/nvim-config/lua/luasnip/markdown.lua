local ls = require('luasnip')
local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
local ins = ls.insert_node --[[@as fun(idx: integer, placeholder?: string)]]
local oneof = ls.choice_node
local sn = ls.snippet_node
local fn = ls.function_node
local dyn = ls.dynamic_node
local text = ls.text_node
local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]
local rep = require('luasnip.extras').rep --[[@as fun(idx: integer)]]
local fmta = require('luasnip.extras.fmt').fmta --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]

return {
  snip(
    'details',
    fmt(
      [[
    <details>
    <summary>{summary}</summary>
    {content}
    </details>
    ]],
      {
        summary = ins(1),
        content = ins(2),
      }
    )
  ),
  snip(
    'vdetails',
    fmt(
      [[
    ::: details {summary}
    {content}
    :::
    ]],
      {
        summary = ins(1),
        content = ins(2),
      }
    )
  ),
  snip(
    'shikihl',
    fmt('{cs} [!code {type}]', {
      cs = dyn(1, function()
        local cs = vim.filetype.get_option(
          require('utils.static').buf.cursor_ft(),
          'commentstring'
        ) --[[@as string]]
        cs = cs:gsub('%%s', string.empty):trim()
        return sn(nil, ins(1, cs))
      end),
      type = oneof(2, {
        text('highlight'),
        text('focus'),
        text('warning'),
        text('error'),
        text('--'),
        text('++'),
      }),
    })
  ),
  snip(
    'vbadge',
    fmt([[<Badge type="{}" text="{}" />]], {
      oneof(1, { text('info'), text('tip'), text('warning'), text('danger') }),
      ins(2),
    })
  ),
  snip(
    'code-group',
    fmt(
      [[
    ::: code-group

    ```{} [{}]

    ```

    :::
    ]],
      { ins(1, 'sh'), ins(2, 'title') }
    )
  ),
}
