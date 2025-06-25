vim.keymap.set(
  'n',
  '<C-b>',
  [[mzhebi**<Esc>ea**<Esc>`z]],
  { buffer = vim.fn.bufnr('%'), desc = 'boldify cursor word', silent = true }
)

vim.keymap.set(
  'x',
  '<C-b>',
  [[mz<Esc>gv<Esc>a**<Esc>gvO<Esc>i**<Esc>`z]],
  { buffer = vim.fn.bufnr('%'), desc = 'boldify selection', silent = true }
)

local checklist_pattern = '^(%s*[%-%*]) %[([ x])%]'
vim.keymap.set('n', '<leader>tk', function()
  local line = vim.api.nvim_get_current_line()

  if line:match(checklist_pattern) then
    local repl = line:gsub(checklist_pattern, function(head, symbol)
      ---@cast head string
      ---@cast symbol string
      return symbol == 'x' and head .. ' [ ]' or head .. ' [x]'
    end, 1)
    vim.api.nvim_set_current_line(repl)
  end
end, { buffer = vim.fn.bufnr('%'), desc = 'toggle checkbox' })

vim.keymap.set('n', [[<leader>ck]], function()
  local line = vim.api.nvim_get_current_line()
  if not line:match(checklist_pattern) then
    local repl = '- [ ] ' .. vim.trim(line)
    vim.api.nvim_set_current_line(repl)
  end
end, {
  desc = 'convert line to check list entry',
  buffer = vim.fn.bufnr('%'),
})
