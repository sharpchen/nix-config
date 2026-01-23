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
  snip('cmdp', fmt('$null = Get-Command {} -ErrorAction Stop', { ins(1, 'cmd') })),
  snip(
    'cmdif',
    fmt(
      [[
    if (Get-Command {} -ErrorAction Ignore) {{
      {}
    }}
    ]],
      { ins(1, 'cmd'), ins(0) }
    )
  ),
  snip(
    'codecheck',
    fmt(
      [[
    & {{ {} *> $null; 0 -eq $LASTEXITCODE }}
    ]],
      { ins(1, 'cmd') }
    )
  ),
  snip(
    'cmdok',
    fmt(
      [[
    if (& {{ {} *> $null; 0 -eq $LASTEXITCODE }}) {{
        {}
    }}
    ]],
      { ins(1, 'cmd'), ins(0) }
    )
  ),
  snip('discard', fmt('$null = {}', { ins(1) })),
  snip(
    'completecmd',
    fmta(
      [[
Register-ArgumentCompleter -CommandName <> -ParameterName <> -ScriptBlock {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
}
  ]],
      { ins(1), ins(2) }
    )
  ),
  snip(
    'completenative',
    fmta(
      [[
Register-ArgumentCompleter -Native -CommandName <> -ScriptBlock {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )
}
  ]],
      { ins(1) }
    )
  ),
  snip(
    'filevalidate',
    text('[ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]')
  ),
  snip(
    'foldervalidate',
    text('[ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]')
  ),
  snip('pathvalidate', text('[ValidateScript({ Test-Path -LiteralPath $_ })]')),
}
