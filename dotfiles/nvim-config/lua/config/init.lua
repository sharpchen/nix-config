require('utils.env')
require('utils.extension')
require('config.set')
require('config.remap')

if IsVscode then require('config.vscode') end

if IsNeovide then require('config.neovide') end

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

local ok = false
local count = 0
while not ok and count <= 5 do
  count = count + 1
  local colo = Env.light and Random { 'xamabah', 'Eva-Light', 'github_light_default' }
    or Random { 'Eva-Dark', 'habamax', 'vscode' }

  ok = pvimcmd { cmd = 'colo', args = { colo } }
end
