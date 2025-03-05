---@class Static
---@field OS_distro string full name of system
---@field OS_short string short name for system
---@field OS_icon string icon of system
local M = {}

M.buf = {
  ---returns filetype of under cursor
  ---@return string
  cursor_ft = function()
    local lang = M.ts.cursor_lang()
    if lang == 'powershell' then
      return 'ps1'
    end
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
      vim.api.nvim_win_set_cursor(0, { linenr, col - 1 })
    end
  end,
}

M.ts = {
  ---returns language name of current position
  ---@return string
  cursor_lang = function()
    local curline = vim.fn.line('.')
    return vim.treesitter.get_parser():language_for_range({ curline, 0, curline, 0 }):lang()
  end,
}

local icons = require('nvim-web-devicons').get_icons_by_operating_system()
if require('utils.env').is_windows then
  M.OS_distro = 'Windows_NT'
  M.OS_short = 'windows'
  M.OS_icon = icons['windows'].icon
else
  local f = io.open('/etc/os-release', 'r')
  if f == nil then
    return
  end
  local content = f:read('*a') --[[@as string]]
  local distro_fullname = content:match('PRETTY_NAME="([^"]+)"')
  local short
  for word in string.gmatch(distro_fullname, '%S+') do
    short = word:lower()
    break
  end
  f:close()
  M.OS_distro = distro_fullname
  M.OS_short = short
  M.OS_icon = icons[short].icon
end

return M
