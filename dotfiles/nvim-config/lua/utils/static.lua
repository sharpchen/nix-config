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

M.highlight = {}

---@param name string
---@return vim.api.keyset.get_hl_info
function M.highlight.get(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false, create = false })
end

---@param name string
---@param style vim.api.keyset.highlight
function M.highlight.set(name, style) vim.api.nvim_set_hl(0, name, style) end

---@param name string
---@param style vim.api.keyset.highlight
function M.highlight.override(name, style)
  -- WARN: highlight.get returns vim.api.keyset.get_hl_info
  -- which is different than vim.api.keyset.highlight
  -- so this might not work expected for all fields defined in vim.api.keyset.highlight
  vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', M.highlight.get(name), style))
end

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
