if vim.g.neovide then
  vim.o.guifont = 'JetBrainsMono Nerd Font'
  vim.opt.linespace = 0

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_transparency = 1

  vim.keymap.set('v', '<sc-c>', '"+y')
  vim.keymap.set('n', '<sc-v>', 'l"+P')
  vim.keymap.set('v', '<sc-v>', '"+P')
  vim.keymap.set('c', '<sc-v>', '<C-o>l<C-o>"+<C-o>P<C-o>l')
  vim.keymap.set('i', '<sc-v>', '<ESC>l"+Pli')
  vim.keymap.set('t', '<sc-v>', '<C-\\><C-n>"+Pi')
end
