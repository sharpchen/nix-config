local async = require('utils').async
---@class Static
---@field OS_distro string full name of system
---@field OS_short string short name for system
---@field OS_icon string icon of system
local M = {
  env = {
    is_windows = false,
    -- do not use it on plugin loading
    has_nix = vim.fn.executable('nix') == 1,
  },
  lsp = {
    vue_language_server = '',
  },
}

if not M.env.is_windows then
  async.cmd({ 'bash', '-c', 'echo -n $(readlink -f $(which vue-language-server))' }, function(result)
    local folder = vim.fs.dirname(vim.fs.dirname(result))
    M.lsp.vue_language_server = vim.fs.joinpath(folder, 'lib/node_modules/@vue/language-server')
  end)
end

local icons = require('nvim-web-devicons').get_icons_by_operating_system()
if vim.uv.os_uname().sysname == 'Windows_NT' then
  M.env.is_windows = true
  M.OS_distro = 'Windows_NT'
  M.OS_short = 'windows'
  M.OS_icon = icons['windows'].icon
  return
end

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

return M
