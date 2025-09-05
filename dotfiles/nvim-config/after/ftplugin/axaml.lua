vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

if not IsWindows then
  -- add support for backslashed path on non-Windows platform
  vim.opt.isfname:append { '\\' }
  vim.bo.includeexpr = [[tr(v:fname, '\', '/')]]
end

if pcall(require, 'match-up') then
  vim.b.match_words = vim.fn['matchup#util#standard_xml']()
end
