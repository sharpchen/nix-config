require('config.remap')
require('config.set')
require('config.lazy')
require('utils')
require('config.neovide')
require('config.wsl')
local colo = { 'Eva-Dark', 'kanagawa-dragon', 'vscode' }
math.randomseed(os.time())
vim.cmd(('colo %s'):format(colo[math.random(#colo)]))
