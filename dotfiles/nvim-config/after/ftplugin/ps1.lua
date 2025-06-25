vim.opt_local.cindent = true
vim.opt_local.cinoptions:append { 'J1', '(1s', '+0' }

vim.opt_local.iskeyword:remove { '-' }

if
  not vim.tbl_isempty(vim.fn.getscriptinfo { name = 'vim-wordmotion' })
  and vim.g.wordmotion_enabled
then
  vim.cmd('WordMotionToggle')
end
