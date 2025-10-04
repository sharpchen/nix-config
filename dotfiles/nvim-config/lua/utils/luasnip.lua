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

local M = {}

---@param opts { query: string, lang: string }
---@return fun(opts: { format: string, trig: string }): any
function M.ts_wrap_stm(opts)
  return function(inner_opts)
    return ts_post({
      trig = inner_opts.trig,
      matchTSNode = {
        query = opts.query,
        query_lang = opts.lang,
        match_captures = { 'prefix' },
      },
    }, {
      dyn(1, function(_, parent)
        local nodes = { stm = text(parent.snippet.env.LS_TSCAPTURE_PREFIX) }
        local idx = 1
        for match in inner_opts.format:gmatch('{(%w*)}') do
          if match:is_nil_or_empty() then
            table.insert(nodes, ins(idx))
            idx = idx + 1
          elseif match ~= 'stm' then
            nodes[match] = ins(idx, match)
            idx = idx + 1
          end
        end
        return sn(nil, fmt(inner_opts.format, nodes, { repeat_duplicates = true }))
      end),
    })
  end
end

return M
