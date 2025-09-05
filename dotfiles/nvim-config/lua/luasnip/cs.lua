local ls = require('luasnip')
local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
local ins = ls.insert_node --[[@as fun(idx: integer, placeholder?: string)]]
local fn = ls.function_node
local sn = ls.snippet_node
local dyn = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]
local rep = require('luasnip.extras').rep --[[@as fun(idx: integer)]]
local text = ls.text_node
local ref = require('luasnip.extras').lambda
local postfix = require('luasnip.extras.postfix').postfix
local ts_post = require('luasnip.extras.treesitter_postfix').treesitter_postfix
local postfix_builtin = require('luasnip.extras.treesitter_postfix').builtin

return {
  ts_post({
    trig = '.var',
    matchTSNode = {
      query = [[
            [
              (invocation_expression)
              (member_access_expression)
              (identifier)
            ] @prefix
        ]],
      query_lang = 'c_sharp',
      match_captures = { 'prefix' },
    },
  }, {
    dyn(1, function(_, parent)
      local node_content = parent.snippet.env.LS_TSCAPTURE_PREFIX
      if type(node_content) == 'table' then
        node_content = table.concat(node_content, '\n')
      end
      return sn(nil, fmt('var {} = {};', { ins(1), text(node_content) }))
    end),
  }),
}
