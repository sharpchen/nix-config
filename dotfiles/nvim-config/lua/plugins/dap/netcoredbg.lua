local dap = require('dap')
local async = require('utils.async')

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
      local target_fm_dirs = dir:get_directories()

      if not dir:exists() or #target_fm_dirs == 0 then
        vim.notify(
          'No debug build found, please build project first.',
          vim.log.levels.WARN
        )
      end

      local dlls = vim.fs.find(
        function(name, _) return name:match('%.dll$') end,
        { path = dir.fullname, limit = math.huge, type = 'file' }
      )

      local ret

      error('not implemented')

      require('fzf-lua').fzf_exec(dlls, {
        actions = {
          default = function(selected, _) ret = selected[1] end,
        },
      })

      return ret
    end,
  },
}
