if pcall(require, 'nvim-treesitter') then vim.cmd([[TSDisable indent]]) end
vim.bo.indentexpr = vim.api.nvim_get_option_value('indentexpr', { filetype = 'cs' })
vim.opt_local.iskeyword:remove { '-' }
