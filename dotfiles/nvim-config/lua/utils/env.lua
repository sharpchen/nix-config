-- NOTE: this module should not run any task and modification on anything

require('utils.extension')
local M = {
  is_windows = jit.os:find('Windows') ~= nil,
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
  has_pwsh = vim.fn.executable('pwsh') == 1,
}

M.new_line = M.is_windows and '\r\n' or '\n'

---generate a command args array for running on new bash process
---@param cmd string the direct command to run within bash
---@return string[]
local function bash_cmd(cmd)
  local ret = { 'bash', '--noprofile', '--norc', '-c' }
  table.insert(ret, cmd)
  return ret
end

---generate a command args array for running on new powershell process
---@param cmd string the direct command to run within bash
---@return string[]
local function pwsh_cmd(cmd)
  local ret = { (M.has_pwsh and 'pwsh' or 'powershell'), '-noprofile', '-nologo', '-c' }
  table.insert(ret, cmd)
  return ret
end

M.shell = {
  bash_cmd = bash_cmd,
  pwsh_cmd = pwsh_cmd,
  cmd_wrap = (not M.is_windows) and bash_cmd or pwsh_cmd,
}

--- Generate a command array that query the store path of a nix package
---@param pkg string main program
---@return string[]
M.mk_store_query = function(pkg)
  return bash_cmd(([[nix-store -q --outputs "$(type -fP %s)"]]):format(pkg))
end

return M
