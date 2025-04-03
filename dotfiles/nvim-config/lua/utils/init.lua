require('utils.extension')
require('utils.env')

if not vim.g.vscode then
  require('utils.lsp')
  require('utils.dap')
end
