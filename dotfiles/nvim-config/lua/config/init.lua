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

local colo = Env.light and Random { 'xamabah', 'Eva-Light' }
  or Random { 'Eva-Dark', 'habamax', 'vscode' }

if not pvimcmd { cmd = 'colo', args = { colo } } then vim.cmd.colo('default') end
