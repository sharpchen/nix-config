local M = {}

---simple async cmd to fetch single result.
---@param cmd string[]
---@param cb? fun(result: string) callback for using returned result
---@param opts? vim.SystemOpts
M.cmd = function(cmd, cb, opts)
  cb = cb or function(_) end
  opts = vim.tbl_extend('keep', opts or {}, { text = true })
  vim.system(cmd, opts, function(out)
    if out.code ~= 0 then
      vim.schedule(function()
        vim.notify(('async job for `%s` exited with code %s.'):format(table.concat(cmd, ' '), tostring(out.code)))
        vim.notify((('error: %s'):format(out.stderr)))
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
