local ls = require('luasnip')
local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
local ins = ls.insert_node --[[@as fun(idx: integer, placeholder?: string)]]
local oneof = ls.choice_node
local sn = ls.snippet_node
local fn = ls.function_node
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
    'shikihl',
    fmt(
      '{cs} [!code <highlight>]',
      { cs = fn(function() return vim.bo.commentstring end) }
    )
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
    ```{}[{}]

    ```
    :::
    ]],
      { ins(1, 'sh'), ins(2, 'title') }
    )
  ),
}
