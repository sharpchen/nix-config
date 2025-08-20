local ls = require('luasnip')
local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
local ins = ls.insert_node --[[@as fun(idx: integer, placeholder: string)]]
local fn = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts?: table)]]
local rep = require('luasnip.extras').rep --[[@as fun(idx: integer)]]

local function classname()
  local cursor_node = vim.treesitter.get_node { ignore_injections = false }
  if not cursor_node then return nil end

  local parent = cursor_node:parent()
  while parent and parent:type() ~= 'class_declaration' do
    parent = parent:parent()
  end

  if not parent then return nil end

  local query = vim.treesitter.query.parse(
    'c_sharp',
    [[
  (class_declaration
    name: (identifier) @class_name)
  ]]
  )
  for _, capture in query:iter_captures(parent, 0) do
    return vim.treesitter.get_node_text(capture, 0)
  end
end

local function pascal2camel(name)
  local words = {}
  for word in name:gmatch('%u%l+') do
    table.insert(words, word)
  end
  local is_pascal = table.concat(words):len() == name:len()
  if is_pascal then
    local first = words[1]
    return first:lower() .. table.concat(vim.list_slice(words, 2))
  else
    return name
  end
end

return {
  snip(
    'directProperty',
    fmt(
      [[
    private {propertyType} _{};

    public static readonly DirectProperty<{controlType}, {propertyType}> {}Property = AvaloniaProperty.RegisterDirect<{controlType}, {propertyType}>(
        nameof({}), o => o.{}, (o, v) => o.{} = v);

    public {propertyType} {}
    {{
        get => _{};
        set => SetAndRaise({}Property, ref _{}, value);
    }}
      ]],
      {
        propertyType = ins(2, 'propertyType'),
        controlType = fn(function() return classname() or 'controlType' end),
        fn(function(args)
          -- return require('utils.text').case.convert(args[1][1] or '', 'camel')
          return pascal2camel(args[1][1] or '')
        end, { 1 }),
        ins(1, 'PropertyName'),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
        fn(function(args)
          -- return require('utils.text').case.convert(args[1][1] or '', 'camel')
          return pascal2camel(args[1][1] or '')
        end, { 1 }),
        rep(1),
        fn(function(args)
          -- return require('utils.text').case.convert(args[1][1] or '', 'camel')
          return pascal2camel(args[1][1] or '')
        end, { 1 }),
      },
      { repeat_duplicates = true }
    )
  ),
  snip(
    'styledProperty',
    fmt(
      [[
    public static readonly StyledProperty<{propertyType}> {propertyName}Property = AvaloniaProperty.Register<{controlType}, {propertyType}>(
        nameof({propertyName}));

    public {propertyType} {propertyName}
    {{
        get => GetValue({propertyName}Property);
        set => SetValue({propertyName}Property, value);
    }}
  ]],
      {
        propertyName = ins(1, 'propertyName'),
        propertyType = ins(2, 'propertyType'),
        controlType = fn(function() return classname() or 'controlType' end),
      },
      { repeat_duplicates = true }
    )
  ),
}
