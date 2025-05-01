local ok, _ = pcall(require, 'nvim-treesitter')
if ok then vim.cmd([[TSDisable indent]]) end
vim.bo.indentexpr = vim.api.nvim_get_option_value('indentexpr', { filetype = 'cs' })
