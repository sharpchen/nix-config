local M = {
  is_windows = jit.os == 'Windows',
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
}

M.new_line = M.is_windows and '\r\n' or '\n'

return M
