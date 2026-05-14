vim.opt.spell = false

local vscode = require('vscode')

vim.notify = vscode.notify

-- NOTE: because indentation is broken on paste
vim.keymap.set('i', '<C-v>', '<C-r><C-p>+')

vim.keymap.set('n', '<leader>o', function() vscode.call('outline.focus') end)

vim.keymap.set('n', '<leader>k', function()
  -- formatting(vscode.action()) is async here
  vscode.action('editor.action.formatDocument')
end)
vim.keymap.set(
  'n',
  '<leader>ca',
  function() vscode.call('editor.action.quickFix') end,
  { desc = 'code actions' }
)
vim.keymap.set(
  'n',
  '<leader>ff',
  function() vscode.call('workbench.action.quickOpen', { args = { '' } }) end,
  { desc = 'search files' }
)

vim.keymap.set(
  'n',
  [[<leader>fg]],
  function()
    vscode.call(
      'workbench.action.quickOpen',
      { args = { '%' .. vim.fn.expand('<cword>') } }
    )
  end,
  { desc = 'desc' }
)

vim.keymap.set('n', 'zM', function() vscode.call('editor.foldAll') end)
vim.keymap.set('n', 'zR', function() vscode.call('editor.unfoldAll') end)
vim.keymap.set('n', 'zc', function() vscode.call('editor.fold') end)
vim.keymap.set('n', 'zC', function() vscode.call('editor.foldRecursively') end)
vim.keymap.set('n', 'zo', function() vscode.call('editor.unfold') end)
vim.keymap.set('n', 'zO', function() vscode.call('editor.unfoldRecursively') end)
vim.keymap.set('n', 'za', function() vscode.call('editor.toggleFold') end)

vim.keymap.set(
  'n',
  [[\]],
  function()
    vscode.action('editor.actions.findWithArgs', {
      args = {
        searchString = vim.fn.expand('<cword>'),
        replaceString = '',
        isRegex = true,
        preserveCase = true,
        isCaseSensitive = true,
      },
    })
  end
)
vim.keymap.set(
  'v',
  [[\]],
  function()
    vscode.action('editor.actions.findWithArgs', {
      args = {
        searchString = vim.fn.expand('<cword>'),
        replaceString = '',
        isRegex = true,
        preserveCase = true,
        isCaseSensitive = true,
        findInSelection = true,
      },
    })
  end
)
