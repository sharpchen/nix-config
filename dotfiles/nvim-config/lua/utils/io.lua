local M = {}
local internal = {}

---@class DirectoryInfo
---@field fullname string
---@field name string
---@field get_directories fun(self: self, pattern?: string, level?: 'top' | 'all'): DirectoryInfo[]
---@field get_files fun(self: self, pattern?: string, level?: 'top' | 'all'): FileInfo[]
M.DirectoryInfo = {}
M.DirectoryInfo.__index = M.DirectoryInfo

M.DirectoryInfo.get_directories = function(self, pattern, level)
  level = level or 'top'
  if pattern then
    return vim
      .iter(internal.ls(self.fullname, level, 'directory'))
      :filter(function(x)
        return x.name:match(pattern) ~= nil
      end)
      :totable()
  end
  return internal.ls(self.fullname, level, 'directory')
end

M.DirectoryInfo.get_files = function(self, pattern, level)
  level = level or 'top'
  if pattern then
    return vim
      .iter(internal.ls(self.fullname, level, 'file'))
      :filter(function(x)
        return x.name:match(pattern) ~= nil
      end)
      :totable()
  end

  return internal.ls(self.fullname, level, 'file')
end

---@param path string
---@return DirectoryInfo
M.DirectoryInfo.new = function(path)
  assert(not string.is_nil_or_empty(path))
  local self = setmetatable({}, M.DirectoryInfo) --[[@as DirectoryInfo]]
  self.name = vim.fs.basename(path)
  self.fullname = vim.fn.expand(path)
  return self
end

M.DirectoryInfo.exists = function(self)
  local state = vim.uv.fs_stat(self.fullname)
  return state and state.type == 'directory'
end

---@class FileInfo
---@field name string
---@field fullname string
---@field extension string
---@field directory_name? string
---@field length integer
---@field directory DirectoryInfo
M.FileInfo = {}
M.FileInfo.__index = M.FileInfo

---@param path string
---@return FileInfo
M.FileInfo.new = function(path)
  assert(not path:is_nil_or_empty())
  local self = setmetatable({}, M.FileInfo)
  self.name = vim.fs.basename(path)
  self.extension = path:sub(path:last_indexof('.'))
  self.fullname = vim.fn.expand(path)
  return self
end

---@param self FileInfo
---@return boolean
M.FileInfo.exists = function(self)
  return vim.fn.filereadable(self.fullname) == 1
end

---@param base string
---@param level 'top' | 'all'
---@param type 'file' | 'directory'
---@return FileInfo[] | DirectoryInfo[]
internal.ls = function(base, level, type)
  local ret = {}
  local scanner = vim.uv.fs_scandir(base)
  if not scanner then
    return {}
  end
  if level == 'top' then
    while true do
      local name, kind = vim.uv.fs_scandir_next(scanner)
      if not name then
        break
      end
      if kind == type then
        local fullname = vim.fs.joinpath(base, name)
        table.insert(ret, type == 'directory' and M.DirectoryInfo.new(fullname) or M.FileInfo.new(fullname))
      end
    end
  else
    while true do
      local name, kind = vim.uv.fs_scandir_next(scanner)
      local fullname = vim.fs.joinpath(base, name)
      if not name then
        break
      end
      if kind == 'directory' then
        ret = vim.list_extend(ret, internal.ls(fullname, 'all', type))
      end
      if kind == type then
        table.insert(ret, type == 'directory' and M.DirectoryInfo.new(fullname) or M.FileInfo.new(fullname))
      end
    end
  end

  return ret
end

return M
