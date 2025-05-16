local M = {}

M.buf = {
  ---returns filetype of under cursor
  ---@return string
  cursor_ft = function()
    local lang = M.ts.cursor_lang()
    if lang == 'powershell' then return 'ps1' end
    return lang == 'c_sharp' and 'cs' or lang
  end,
}

M.mark = {
  --- wrap an action to make sure the cursor stays still
  ---@param action fun()
  ---@return fun()
  wrap = function(action)
    return function()
      local bufnr, linenr, colnr, _ = unpack(vim.fn.getpos('.'))
      vim.api.nvim_buf_set_mark(bufnr, 'z', linenr, colnr, {})
      action()
      local row, col, _, _ = unpack(vim.api.nvim_buf_get_mark(bufnr, 'z'))
      -- NOTE: row returned from nvim_buf_get_mark is sometimes unexpectedly 0
      -- use original linenr instead here since they're always in the same line
      vim.api.nvim_win_set_cursor(0, { linenr, col - 1 })
    end
  end,
}

M.ts = {
  ---returns language name of current position
  ---@return string
  cursor_lang = function()
    local curline = vim.fn.line('.')
    return vim.treesitter
      .get_parser()
      :language_for_range({ curline, 0, curline, 0 })
      :lang()
  end,
}

M.snippet = {
  --- simple snippet definition
  --- only for snippets have successive index
  --- use <> as delimiters by default
  ---@param filetype string | string[]
  ---@param trigger string | { trig: string, name: string, desc: string }
  ---@param body string
  ---@param opts? { delimiters?: string }
  add = function(filetype, trigger, body, opts)
    local ok, ls = pcall(require, 'luasnip')
    if not ok then return end
    local snip = ls.snippet --[[@as fun(trigger: string | { trig: string, name: string, desc: string }, node: any[] | any)]]
    local oneof = ls.c --[[@as fun(idx: integer, choices: any[], opts: table)]]
    local text = ls.t --[[@as fun(text: string)]]
    local insert = ls.i --[[@as fun(idx: integer, placeholder: string)]]
    local fmt = require('luasnip.extras.fmt').fmt --[[@as fun(body: string, nodes: any[] | any, opts: table)]]

    opts = (opts and opts.delimiters) and opts or { delimiters = '<>' }
    local l, r = opts.delimiters:sub(1, 1), opts.delimiters:sub(2, 2)
    local placeholders = Collect(body:gmatch(l:verbatim() .. '(.-)' .. r:verbatim()))
    local body, count = body:gsub(l:verbatim() .. '.-' .. r:verbatim(), opts.delimiters)
    local nodes = {}

    for i = 1, count do
      table.insert(nodes, insert(i, placeholders[i]))
    end

    for _, ft in ipairs(type(filetype) == 'table' and filetype or { filetype }) do
      ls.add_snippets(ft, {
        snip(trigger, fmt(body, nodes, opts)),
      })
    end

    -- vim.notify(vim.inspect(placeholders))
  end,
}

---@param next boolean
local function mv_qf_item(next, init_bufnr)
  local is_top = vim.fn.line('.') == 1
  local is_bottom = vim.fn.line('.') == vim.fn.line('$')

  local is_not_init_buf = false
  -- go back to file so we can delete the buf
  if vim.bo.filetype == 'qf' then
    vim.cmd('wincmd p')
    is_not_init_buf = vim.fn.bufnr('%') ~= init_bufnr
  end

  if is_not_init_buf then vim.cmd('bd | copen') end

  if is_top and not next then
    vim.cmd('clast')
  elseif is_bottom and next then
    vim.cmd('cfirst')
  else
    vim.cmd(next and 'cn' or 'cN')
  end

  -- center location
  vim.api.nvim_feedkeys('zz', 'tx', false)

  -- resize qf(should stay in file)
  vim.cmd(
    string.format(
      'res %s',
      math.floor(
        (
          vim.o.lines
          - vim.o.cmdheight
          - (vim.o.laststatus == 0 and 0 or 1)
          - (vim.o.tabline == '' and 0 or 1)
        )
            / 3
            * 2
          + 0.5
      ) + 3
    )
  )

  -- make sure go back to qf
  if vim.bo.filetype ~= 'qf' then vim.cmd('copen') end
end
_ = mv_qf_item

return M
