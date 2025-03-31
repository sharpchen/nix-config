vim.keymap.set(
  'n',
  '<C-b>',
  [[mz:s/\<<C-r><C-w>\>/**<C-r><C-w>**/<CR>`z]],
  { buffer = vim.fn.bufnr('%'), desc = 'boldify cursor word' }
)

vim.keymap.set(
  'v',
  '<C-b>',
  [[mz"zy:s/\<<C-r>z\>/**<C-r>z**/<CR>`z]],
  { buffer = vim.fn.bufnr('%'), desc = 'boldify selection' }
)
