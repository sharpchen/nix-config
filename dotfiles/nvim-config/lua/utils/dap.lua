local async = require('utils').async
local M = {
  path = {
    netcoredbg = string.empty,
  },
}

if not require('utils.env').is_windows then
  async.cmd({ 'bash', '-c', 'which netcoredbg' }, function(result)
    M.path.netcoredbg = result
  end)
end

return M
