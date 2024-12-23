local async = require('utils.async')
local M = {
  is_windows = jit.os == 'Windows',
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
}

M.new_line = M.is_windows and '\r\n' or '\n'

local bash_prefix = { 'bash', '--noprofile', '--norc', '-c' }
--- Generate a command array that query the store path of a nix package
---@param pkg string main program
---@return string[]
M.mk_store_query = function(pkg)
  return { 'bash', '--noprofile', '--norc', '-c', ([[nix-store -q --outputs "$(type -fP %s)"]]):format(pkg) }
end

if not M.is_windows then
  async.cmd(vim.list_extend(bash_prefix, { [[fd -t=d aspell-dict-en /nix/store]] }), function(res)
    vim.notify(vim.inspect(res))
  end)
end

return M
