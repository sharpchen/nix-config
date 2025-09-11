require('utils.env')
require('utils.extension')
require('config.set')
require('config.remap')

if vim.g.vscode then
  require('config.vscode')
  return
end

if vim.g.neovide then require('config.neovide') end

require('config.lazy')

require('config.wsl') -- requires plugin
require('utils.lsp') -- tasks
require('utils.dap') -- tasks

local colo = { 'Eva-Dark', 'vscode', 'kanagawa-dragon', 'rose-pine-moon' }
if IsWindows then
  vim.cmd.colorscheme('vscode')
else
  math.randomseed(os.time())
  vim.cmd.colo(colo[math.random(#colo)])
end
