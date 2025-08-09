---@module 'lazy'
---@type LazySpec
return {
  'L3MON4D3/LuaSnip',
  branch = 'master',
  dependencies = { 'rafamadriz/friendly-snippets' },
  build = 'make install_jsregexp',
  event = 'VeryLazy',
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()

    local add = require('utils.static').snippet.add

    -- TODO: use this to parse snippet literal
    _ = require('luasnip').parser.parse_snippet

    add(
      'lua',
      'keymap',
      "vim.keymap.set('<n>', [[<keyseq>]], <action>, { desc = '<desc>' })"
    )
    add(
      'lua',
      'lkeymap',
      "vim.keymap.set('<n>', [[<keyseq>]], <action>, { desc = '<desc>', , buffer = vim.fn.bufnr('%') })"
    )
    add(
      'lua',
      'pcre',
      [[
    local ok, <name> = pcall(require, '<module>')
    if not ok then return end
    ]]
    )
    add(
      'lua',
      'au',
      [[
      vim.api.nvim_create_autocmd('<event>', {
        callback = function (args)
          <-- body>
        end
      })
        ]]
    )
    add(
      'lua',
      'usercmd',
      [[ vim.api.nvim_create_user_command('<name>', <action>, { desc = '<desc>' }) ]]
    )
    add(
      'lua',
      'lazyspec',
      [[
    ---@module 'lazy'
    ---@type LazySpec
        ]]
    )
    add(
      'lua',
      'ctor',
      [[
    ---@generic T
    ---@param self T
    ---@param o? T | table
    ---@return T
    function <Class>:new(o)
      o = o or {}
      self.__index = self
      return setmetatable(o, self)
    end
    ]]
    )
    -- add(
    --   { 'cs', 'typescript', 'javascript', 'lua', 'json' },
    --   'lambda',
    --   '([param]) => [/* body */]',
    --   { delimiters = '[]' }
    -- )
    add(
      'markdown',
      'details',
      [[
        <details>
        <summary>{summary}</summary>
        {content}
        </details>
        ]],
      { delimiters = '{}' }
    )
    add('markdown', 'shikihl', '<//> [!code <highlight>]')
    add(
      'markdown',
      'vbadge',
      [[<Badge type="{info}" text="{text}" />]],
      { delimiters = '{}' }
    )
    add(
      'markdown',
      'code-group',
      [[
    ::: code-group

    :::
    ]]
    )
    add('ps1', 'cmdp', '$null = Get-Command <cmd> -ErrorAction Stop')
    add(
      'ps1',
      'cmdif',
      [[
    if (Get-Command <cmd> -ErrorAction Ignore) {
      <# body>
    }
    ]]
    )
    add(
      'ps1',
      'codecheck',
      [[
    & { [cmd] *> $null; 0 -eq $LASTEXITCODE }
    ]],
      { delimiters = '[]' }
    )
    add(
      'ps1',
      'codeif',
      [[
    if (& { [cmd] *> $null; 0 -eq $LASTEXITCODE }) {
      [# action]
    }
    ]],
      { delimiters = '[]' }
    )
    add(
      'sh',
      'cmdif',
      [[
    if type {cmd} &>/dev/null; then
      {# body}
    fi
    ]],
      { delimiters = '{}' }
    )
    add(
      'nix',
      'mod',
      [[
        { pkgs, config, lib, ...  }:
        {
          <# here>
        }
        ]]
    )
  end,
}
