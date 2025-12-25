vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

-- local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
-- for _, line in ipairs(lines) do
--   -- Remove everything within quotes (basic handling of strings)
--   local without_string = line:gsub('".-"', '')
--   -- Check for line or block comments
--   if without_string:match('%/%/') or without_string:match('%/%*') then
--     vim.bo.filetype = 'jsonc'
--     break
--   end
-- end
