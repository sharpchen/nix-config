require('utils.env')
require('utils.extension')
require('config.set')
require('config.remap')

if vim.g.vscode then
  require('config.vscode')
  return
end

if vim.g.neovide then require('config.neovide') end

if vim.env.MINIMAL_NVIM == '1' then
  local colo = Env.light and 'default' or 'habamax'
  local bg = Env.light and 'light' or 'dark'
  if bg ~= vim.o.background then vim.o.background = bg end
  if colo ~= vim.g.colors_name then vim.cmd.colo(colo) end
  return
end

require('config.lazy')
-- require('config.wsl')
require('utils.lsp')
require('utils.dap')

local function random(arr)
  math.randomseed(os.time())
  return arr[math.random(#arr)]
end

vim.cmd.colo(
  Env.light and random { 'xamabah', 'Eva-Light' }
    or random { 'Eva-Dark', 'habamax', 'vscode' }
)
