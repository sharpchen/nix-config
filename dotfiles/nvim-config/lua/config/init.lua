if vim.g.vscode then
  require('config.vscode')
  return
end

require('config.remap')
require('config.set')
require('config.lazy')
require('utils')
require('config.neovide')
require('config.wsl')

if vim.g.started_by_firenvim then
  vim.o.laststatus = 0
  vim.o.background = 'light'
end

if require('utils.env').is_windows then
  vim.cmd.colorscheme('vscode')
else
  local colo = { 'Eva-Dark', 'vscode', 'kanagawa' }
  math.randomseed(os.time())
  vim.cmd.colorscheme(colo[math.random(#colo)])
end
