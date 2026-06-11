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

---@param word string
local function make_comment(word)
  return snip(
    word,
    dyn(1, function()
      local ok, ft = pcall(require('utils.static').buf.cursor_ft)

      if ok then
        ok, cs = pcall(vim.filetype.get_option, ft, 'commentstring')
      end

      ---@cast cs string
      if not ok or cs == '' then
        return sn(nil, {})
      else
        local format = cs:gsub('%%s', word:upper() .. ': {}'):trim()
        return sn(nil, fmt(format, { ins(1) }))
      end
    end)
  )
end

return {
  make_comment('todo'),
  make_comment('fixme'),
  make_comment('note'),
  make_comment('warn'),
  make_comment('perf'),
}
