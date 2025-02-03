require('config.remap')
require('config.set')
require('config.lazy')
require('utils')
require('config.neovide')
require('config.wsl')
if require('utils.env').is_windows then
  vim.cmd([[colo vscode]])
else
  local colo = { 'Eva-Dark', 'vscode', 'kanagawa' }
  math.randomseed(os.time())
  vim.cmd(('colo %s'):format(colo[math.random(#colo)]))
end
