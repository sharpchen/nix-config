local async = require('utils').async
---@class Static
---@field OS_distro string full name of system
---@field OS_short string short name for system
---@field OS_icon string icon of system
local M = {}

M.env = {
  is_windows = vim.uv.os_uname().sysname == 'Windows_NT',
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
}

M.lsp = {
  path = {
    vue_language_server = '',
  },
  event = {
    ---@param client vim.lsp.Client
    disable_formatter = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    ---@param client vim.lsp.Client
    disable_semantic = function(client)
      client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}

M.buf = {
  ---returns filetype of under cursor
  ---@return string
  cursor_ft = function()
    local lang = M.ts.cursor_lang()
    return lang == 'c_sharp' and 'cs' or lang
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

if not M.env.is_windows then
  async.cmd({ 'bash', '-c', 'echo -n $(readlink -f $(which vue-language-server))' }, function(result)
    local folder = vim.fs.dirname(vim.fs.dirname(result))
    M.lsp.path.vue_language_server = vim.fs.joinpath(folder, 'lib/node_modules/@vue/language-server')
  end)
end

local icons = require('nvim-web-devicons').get_icons_by_operating_system()
if M.env.is_windows then
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
