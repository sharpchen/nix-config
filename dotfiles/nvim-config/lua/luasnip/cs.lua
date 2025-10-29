local ls = require('luasnip')
local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
local ins = ls.insert_node
local oneof = ls.choice_node
local fn = ls.function_node
local sn = ls.snippet_node
local dyn = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep --[[@as fun(idx: integer)]]
local text = ls.text_node
local ref = require('luasnip.extras').lambda
local postfix = require('luasnip.extras.postfix').postfix
local ts_post = require('luasnip.extras.treesitter_postfix').treesitter_postfix
local postfix_builtin = require('luasnip.extras.treesitter_postfix').builtin

local wrap_cs_stm = require('utils.luasnip').ts_wrap_stm {
  lang = 'c_sharp',
  query = [[
            [
              (invocation_expression)
              (member_access_expression)
              (element_access_expression)
              (conditional_access_expression)
              (range_expression)
              (integer_literal)
              (real_literal)
              (string_literal)
              (character_literal)
              (identifier)
            ] @prefix
        ]],
}

return {
  wrap_cs_stm { trig = '.var', format = 'var {} = {stm};' },
  wrap_cs_stm { trig = '.wl', format = 'Console.WriteLine({stm});' },
  wrap_cs_stm {
    trig = '.foreach',
    format = [[
  foreach (var {item} in {stm}) {{
    {}
  }}
  ]],
  },
  snip(
    'lambda',
    fmt('({param}) => {body}', {
      param = ins(1),
      body = oneof(2, {
        sn(nil, fmta('{ <> }', { ins(1) })),
        ins(nil),
      }),
    })
  ),
}
