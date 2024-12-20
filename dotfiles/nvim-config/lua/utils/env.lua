local M = {
  is_windows = jit.os == 'Windows',
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
}

M.new_line = M.is_windows and '\r\n' or '\n'

--- Generate a command array that query the store path of a nix package
---@param pkg string package name
---@return string[]
M.mk_store_query = function(pkg)
  return { 'bash', '-c', ([[nix-store -q --outputs "$(type -fP %s)"]]):format(pkg) }
end

return M
