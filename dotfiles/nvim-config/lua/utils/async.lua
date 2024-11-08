local M = {}

---simple async cmd to fetch single result.
---@param cmd string[]
---@param cb? fun(result: string) callback for using returned result
M.cmd = function(cmd, cb)
  cb = cb or function(_) end
  vim.system(cmd, { text = true }, function(out)
    if out.code ~= 0 then
      vim.schedule(function()
        vim.notify(('async job for `%s` exited with code %s.'):format(table.concat(cmd, ' '), tostring(out.code)))
      end)
      return
    end
    local result = vim.trim(out.stdout)
    vim.schedule(function()
      cb(result)
    end)
  end)
end

return M
