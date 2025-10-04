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

local wrap_ts_stm = require('utils.luasnip').ts_wrap_stm {
  lang = 'typescript',
  query = [[
            [
              (member_expression)
              (subscript_expression)
              (call_expression)
              (new_expression)
              (string)
              (number)
              (identifier)
            ] @prefix
        ]],
}

return {
  wrap_ts_stm { trig = '.const', format = 'const {} = {stm}' },
  wrap_ts_stm { trig = '.var', format = 'var {} = {stm}' },
  wrap_ts_stm { trig = '.let', format = 'let {} = {stm}' },
  wrap_ts_stm { trig = '.wl', format = 'console.log({stm})' },
}
