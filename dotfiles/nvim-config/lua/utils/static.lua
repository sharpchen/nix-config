---@class Static
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

return M
