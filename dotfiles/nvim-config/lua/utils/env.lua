local M = {
  is_windows = vim.uv.os_uname().sysname == 'Windows_NT',
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
}

return M
