require('config.remap')
require('config.set')
require('config.lazy')
require('utils.static')
require('config.neovide')
require('config.wsl')
local colo = { 'Eva-Dark', 'kanagawa-dragon', 'vscode' }
vim.cmd(('colo %s'):format(colo[math.random(1, #colo)]))
