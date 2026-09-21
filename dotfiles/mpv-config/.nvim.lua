if vim.lsp.is_enabled('tsgo') then vim.lsp.enable('tsgo', false) end
if vim.lsp.is_enabled('tsc') then vim.lsp.enable('tsc', false) end

vim.lsp.enable('ts_ls')
