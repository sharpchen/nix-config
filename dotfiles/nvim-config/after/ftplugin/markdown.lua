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

vim.keymap.set('i', '*', '**<Left>', { buffer = vim.fn.bufnr('%') })
vim.keymap.set('i', '~', '~~<Left>', { buffer = vim.fn.bufnr('%') })

vim.keymap.set('n', '<leader>ck', function()
  local line = vim.api.nvim_get_current_line()
  local pattern = '^(%s*[%-%*]) %[([ x])%]'

  if line:match(pattern) then
    local repl = line:gsub(pattern, function(head, symbol)
      ---@cast head string
      ---@cast symbol string
      return symbol == 'x' and head .. ' [ ]' or head .. ' [x]'
    end, 1)
    vim.api.nvim_set_current_line(repl)
  end
end, { buffer = vim.fn.bufnr('%'), desc = 'toggle checkbox' })
