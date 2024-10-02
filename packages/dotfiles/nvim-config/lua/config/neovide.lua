if vim.g.neovide then
  vim.o.guifont = 'JetBrainsMono Nerd Font'
  vim.opt.linespace = 0

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_transparency = 1

  vim.keymap.set('v', '<sc-c>', '"+y', { noremap = true })
  vim.keymap.set('n', '<sc-v>', 'l"+P', { noremap = true })
  vim.keymap.set('v', '<sc-v>', '"+P', { noremap = true })
  vim.keymap.set('c', '<sc-v>', '<C-o>l<C-o>"+<C-o>P<C-o>l', { noremap = true })
  vim.keymap.set('i', '<sc-v>', '<ESC>l"+Pli', { noremap = true })
  vim.keymap.set('t', '<sc-v>', '<C-\\><C-n>"+Pi', { noremap = true })
end
