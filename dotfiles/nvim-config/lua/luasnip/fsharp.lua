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

return {
  snip('ll', fmt('-> {}', { ins(0) })),
  snip('LL', fmt('|> {}', { ins(0) })),
  snip('hh', fmt('<- {}', { ins(0) })),
  snip('HH', fmt('<| {}', { ins(0) })),
  snip('ge', fmt('>= {}', { ins(0) })),
  snip('le', fmt('<= {}', { ins(0) })),
  snip('ne', fmt('<> {}', { ins(0) })),
}
