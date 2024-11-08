local dap = require('dap')

dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      local DirectoryInfo = require('utils.io').DirectoryInfo
      local dir = DirectoryInfo.new(vim.fs.joinpath(vim.uv.cwd(), '/bin/Debug/'))
      local debug_dirs = dir:get_directories()
      if not dir:exists() or #debug_dirs == 0 then
        vim.notify('No debug build found, please build project first.', vim.log.levels.WARN)
      end

      if #debug_dirs == 1 then
        return debug_dirs[1]:get_files('%.dll$')[1].fullname or nil
      end

      -- TODO: if has multiple dll, choose one with telescope

      error('No suitable dll file was found.')
    end,
  },
}
