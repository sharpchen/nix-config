local ls = require('luasnip')
local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
local ins = ls.insert_node
local oneof = ls.choice_node
local sn = ls.snippet_node
local fn = ls.function_node
local text = ls.text_node
local dyn = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]
local rep = require('luasnip.extras').rep --[[@as fun(idx: integer)]]
local fmta = require('luasnip.extras.fmt').fmta --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]
local ref = require('luasnip.extras').lambda
local postfix = require('luasnip.extras.postfix').postfix
local ts_post = require('luasnip.extras.treesitter_postfix').treesitter_postfix
local opt = require('luasnip.nodes.optional_arg').new_opt
local key = require('luasnip.nodes.key_indexer').new_key

local wrap_lua_stm = require('utils.luasnip').ts_wrap_stm {
  lang = 'lua',
  query = [[
            [
              (function_call)
              (function_declaration
                name: (MISSING identifier)) ; function literal has missing name
              (dot_index_expression)
              (parenthesized_expression)
              (table_constructor)
              (string)
              (number)
              (identifier)
            ] @prefix
        ]],
}
local wrap_lua_string_stm = require('utils.luasnip').ts_wrap_stm {
  lang = 'lua',
  query = [[
            [
              (string)
            ] @prefix
        ]],
}

return {
  wrap_lua_stm { trig = '.local', format = 'local {} = {stm}' },
  wrap_lua_stm { trig = '.wl', format = 'print({stm})' },
  wrap_lua_stm { trig = '.append', format = 'table.insert({stm}, {})' },
  wrap_lua_stm { trig = '.remove', format = 'table.remove({stm}, {})' },
  wrap_lua_stm { trig = '.type', format = 'type({stm})' },
  wrap_lua_stm { trig = '.assert', format = 'assert({stm})' },
  wrap_lua_stm { trig = '.len', format = '#{stm}' },
  wrap_lua_string_stm { trig = '.format', format = 'string.format({stm}, {})' },
  wrap_lua_stm {
    trig = '.any',
    format = [[
    vim.iter({stm}):any(function({x}) {} end)
  ]],
  },
  wrap_lua_stm {
    trig = '.all',
    format = [[
    vim.iter({stm}):all(function({x}) {} end)
  ]],
  },
  wrap_lua_stm {
    trig = '.find',
    format = [[
    vim.iter({stm}):find(function({x}) {} end)
  ]],
  },
  wrap_lua_stm {
    trig = '.for',
    format = [[
    for _, {value} in ipairs({stm}) do
      {}
    end
  ]],
  },
  wrap_lua_stm {
    trig = '.forp',
    format = [[
    for {key}, {value} in pairs({stm}) do
      {}
    end
  ]],
  },
  snip(
    'kmap',
    fmt("vim.keymap.set('{}', '{}', {}, {{ desc = '{}' }})", {
      ins(1, 'n'),
      sn(2, fmt('<leader>{}', { ins(1) })),
      oneof(3, {
        sn(nil, fmt('function() {} end', { ins(1) })),
        sn(nil, fmt("'<cmd>{}<CR>'", { ins(1) })),
        sn(nil, fmt("':{}<CR>'", { ins(1) })),
        sn(nil, fmt("'{}'", { ins(1) })),
      }),
      ins(4),
    })
  ),
  snip(
    'lkmap',
    fmt("vim.keymap.set('{}', '{}', {}, {{ desc = '{}', buffer = 0 }})", {
      ins(1, 'n'),
      sn(2, fmt('<leader>{}', { ins(1) })),
      oneof(3, {
        sn(nil, fmt('function() {} end', { ins(1) })),
        sn(nil, fmt("'<cmd>{}<CR>'", { ins(1) })),
        sn(nil, fmt("':{}<CR>'", { ins(1) })),
      }),
      ins(4),
    })
  ),
  snip(
    'au',
    fmt("vim.api.nvim_create_autocmd('{}', {{\n" .. '  {}\n' .. '}})', {
      ins(1, 'FileType'),
      oneof(2, {
        sn(nil, fmt('callback = function(args)\n' .. '    {}\n' .. '  end', { ins(1) })),
        sn(nil, fmt("command = '{}',", { ins(1) })),
      }),
    })
  ),
  snip(
    'usercmd',
    fmt("vim.api.nvim_create_user_command('{}', {}, {{ desc = '{}' }})", {
      dyn(1, function(args)
        if args[1] and not require('utils.text').case.is_pascal(tostring(args[1])) then
          return sn(nil, {
            ins(
              1,
              require('utils.text').case.convert(tostring(args[1]), 'pascal'),
              { key = 'cmd' }
            ),
          })
        else
          return sn(nil, { ins(1, args[1], { key = 'cmd' }) })
        end
      end, { opt(key('cmd')) }, { snippetstring_args = true }),
      oneof(2, {
        sn(nil, fmt('function(args)\n  {}\nend', { ins(1) })),
        sn(nil, fmt("'{}'", { ins(1) })),
      }),
      ins(3),
    })
  ),
  snip('lazyspec', text { "---@module 'lazy'", '---@type LazySpec' }),
  snip(
    'ctor',
    fmt(
      [[
  ---@generic T
  ---@param self T
  ---@param o? T | table
  ---@return T
  function {}:new(o)
    o = o or {{}}
    self.__index = self
    return setmetatable(o, self)
  end
  ]],
      { ins(1) }
    )
  ),
}
