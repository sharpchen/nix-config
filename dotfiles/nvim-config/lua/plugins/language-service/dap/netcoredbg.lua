local dap = require('dap')

vim.api.nvim_create_user_command('DotnetDefaultProj', function(_)
  local projs = vim.fs.find(
    function(name, _) return name:match('%.%w+proj$') end,
    { limit = math.huge, type = 'file', path = vim.uv.cwd() }
  )

  vim.ui.select(projs, {
    prompt = 'Select a default launch project> ',
    format_item = function(proj)
      local ret, _ = vim.fs.basename(proj):gsub('%.%w+proj$', '')
      return ret
    end,
  }, function(choice) vim.g.dotnet_default_project = choice end)
end, { desc = 'Pick one project as dotnet default project' })

---@return string
local function program()
  vim.notify('Launching netcoredbg...', vim.log.levels.INFO, { title = 'DAP' })
  vim.wait(300)

  local proj
  if not vim.g.dotnet_default_project then
    vim.fs.root(0, function(name, path)
      ---@cast name string
      if name:match('%.%w+proj$') then proj = vim.fs.joinpath(path, name) end
    end)
  end
  proj = vim.g.dotnet_default_project or proj
  assert(vim.uv.fs_stat(proj) ~= nil, proj .. ' does not exist')

  local build_succeeded = true
  vim
    .system({ 'dotnet', 'build', '-c', 'Debug', proj }, { text = true }, function(out)
      if out.code ~= 0 then
        vim.notify(out.stdout, vim.log.levels.ERROR, { title = 'MSBuild' })
        build_succeeded = false
      end
    end)
    :wait()

  assert(build_succeeded, 'Build FAILED')

  local tfm, assemblyname, output_path, appendtfm
  local res ---@type { Properties: { TargetFramework: string, TargetFrameworks: string, AssemblyName: string, AppendTargetFrameworkToOutputPath: string, OutputPath: string } }
  -- NOTE: <OutputPath>, <AssemblyName>, <AppendTargetFrameworkToOutputPath> compose the final dll path
  vim
    .system({
      'dotnet',
      'msbuild',
      '-getProperty:OutputPath,TargetFramework,TargetFrameworks,AssemblyName,AppendTargetFrameworkToOutputPath',
      proj,
    }, { text = true }, function(out)
      assert(out.code == 0, 'Retrieving MSBuild Properties failed')
      res = vim.json.decode(vim.trim(out.stdout))
    end)
    :wait()

  if res.Properties.TargetFramework ~= '' then
    tfm = res.Properties.TargetFramework
  else
    if res.Properties.TargetFrameworks ~= '' then
      local fms = vim.split(res.Properties.TargetFrameworks, ';', { trimempty = true })
      if #fms == 1 then
        tfm = fms[1]
      else
        tfm = require('dap.ui').pick_one(fms, 'Select one Target Build to attach>')
      end
    end
  end

  assemblyname = res.Properties.AssemblyName
  output_path = res.Properties.OutputPath
  appendtfm = res.Properties.AppendTargetFrameworkToOutputPath == 'true' and true or false

  -- NOTE:
  -- if <TargetFramework>net9.0</TargetFramework> then <OutputPath>bin/Debug/net9.0</OutputPath>
  -- if <TargetFrameworks>net9.0;net8.0</TargetFrameworks> then <OutputPath>bin/Debug</OutputPath>
  -- if <AppendTargetFrameworkToOutputPath> is false, <TargetFramework> is absent in dll path
  local dll = vim.fs.joinpath(
    vim.uv.cwd(),
    output_path,
    (not output_path:find(tfm) and appendtfm) and tfm or '',
    assemblyname .. '.dll'
  )
  assert(vim.uv.fs_stat(dll) ~= nil, dll .. ' does not exist')

  return dll
end

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
    program = program,
  },
}

dap.configurations.fsharp = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = program,
  },
}

dap.configurations.vb = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = program,
  },
}
