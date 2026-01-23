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

local function random(arr)
  math.randomseed(os.time())
  return arr[math.random(#arr)]
end

local now = os.date('*t') --[[@as std.osdate]]

vim.cmd.colo(
  now.hour > 7 and now.hour < 17 and random { 'xamabah', 'Eva-Light' }
    or random { 'Eva-Dark', 'habamax', 'vscode' }
)
