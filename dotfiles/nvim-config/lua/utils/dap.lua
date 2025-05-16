local async = require('utils.async')
local mk_store_query = require('utils.env').mk_store_query
local M = {
  path = {
    netcoredbg = string.empty,
    vscode_js_debug = string.empty,
  },
}

if HasNix then
  async.cmd(
    require('utils.env').shell.bash_cmd('which netcoredbg'),
    function(result) M.path.netcoredbg = result end
  )
  async.cmd(mk_store_query('js-debug'), function(result)
    local path =
      vim.fs.joinpath(result, 'lib/node_modules/js-debug/dist/src/dapDebugServer.js')
    if vim.fn.filereadable(path) == 0 then vim.notify('js-debug not found') end
    M.path.vscode_js_debug = path
  end)
end

return M
