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
    'mod',
    fmta(
      [[
    { pkgs, config, lib, ...  }:
    {
      <>
    }
    ]],
      { ins(0) }
    )
  ),
}
