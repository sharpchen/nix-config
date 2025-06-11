if pcall(require, 'nvim-treesitter') then vim.cmd([[TSDisable indent]]) end
vim.bo.indentexpr = vim.api.nvim_get_option_value('indentexpr', { filetype = 'cs' })
vim.opt_local.iskeyword:remove { '-' }

if
  not vim.tbl_isempty(vim.fn.getscriptinfo { name = 'vim-wordmotion' })
  and vim.g.wordmotion_enabled
then
  vim.cmd('WordMotionToggle')
end
