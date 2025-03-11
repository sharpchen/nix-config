local async = require('utils.async')
require('utils.extension')
local M = {
  is_windows = jit.os == 'Windows',
  -- do not use it on plugin loading
  has_nix = vim.fn.executable('nix') == 1,
}

M.new_line = M.is_windows and '\r\n' or '\n'

---generate a command args array for running on new bash process
---@param cmd string the direct command to run within bash
---@return string[]
local function bash_cmd(cmd)
  local ret = { 'bash', '--noprofile', '--norc', '-c' }
  table.insert(ret, cmd)
  return ret
end

---generate a command args array for running on new powershell process
---@param cmd string the direct command to run within bash
---@return string[]
local function pwsh_cmd(cmd)
  local ret = { 'powershell', '-noprofile', '-nologo', '-c' }
  table.insert(ret, cmd)
  return ret
end

M.shell = {
  bash_cmd = bash_cmd,
  pwsh_cmd = pwsh_cmd,
}

--- Generate a command array that query the store path of a nix package
---@param pkg string main program
---@return string[]
M.mk_store_query = function(pkg)
  return bash_cmd(([[nix-store -q --outputs "$(type -fP %s)"]]):format(pkg))
end

if vim.fn.executable('dotnet') == 1 then
  async.cmd(
    M.is_windows and pwsh_cmd([[dotnet new list | select -skip 4]]) or bash_cmd([[dotnet new list | tail -n +5]]),
    function(res)
      ---@class DotnetTemplateInfo
      ---@field name string template name
      ---@field shortname string template short name
      ---@field lang string lang
      ---@field tags string tags

      ---@type DotnetTemplateInfo[]
      _G.dotnet_templates = {}
      for _, line in ipairs(vim.split(res, '\n')) do
        local pattern = [[^\(\([a-z0-9\.()\-]\+\s\)\+\)\s\+\([a-z0-9\.\-,]\+\)\s\+\(.\{-}\)\s\+\(.\{-}$\)]]
        local matches = vim.fn.matchlist(line, pattern)
        matches = vim.list_slice(
          vim
            .iter(matches)
            :map(function(m)
              return vim.trim(m)
            end)
            :totable(),
          2
        ) -- we don't need whole match

        -- NOTE: count matters to pick exact match for fields
        -- but match could be empty, so we should slice by finding index range of matches
        local last_idx = nil

        for idx, m in ipairs(matches) do
          -- NOTE: for some templates might not have lang
          -- this is the only case the match would be empty
          -- so here has to find the idx to slice by prev/next
          if m == '' and matches[idx + 1] ~= '' and idx ~= #matches then
            last_idx = idx + 1
            break
          end
        end

        -- if lang is not empty, just don't slice
        if last_idx ~= nil then
          matches = vim.list_slice(matches, 1, last_idx)
        else
          matches = vim
            .iter(matches)
            :filter(function(m)
              return m ~= ''
            end)
            :totable()
        end

        -- NOTE: should remove child match, 1 at most?
        local idx_rm
        -- should skip first match(the whole match)
        for idx = 1, #matches - 1, 1 do
          local m = matches[idx] --[[@as string]]
          -- the child match always part of the parent
          if m:find(matches[idx + 1]) then
            idx_rm = idx + 1
            break
          end
        end

        if idx_rm then
          table.remove(matches, idx_rm)
        end

        -- NOTE: should have 4 fields, the exception is when lang is empty
        if #matches < 4 then
          name, shortname, tags = unpack(matches)
          lang = ''
        else
          name, shortname, lang, tags = unpack(matches)
        end

        if shortname:find(',') then
          for _, sn in ipairs(vim.split(shortname, ',')) do
            table.insert(_G.dotnet_templates, { name = name, shortname = sn, lang = lang, tags = tags })
          end
        else
          table.insert(_G.dotnet_templates, { name = name, shortname = shortname, lang = lang, tags = tags })
        end

        -- local pattern = [[^\(\([a-z0-9\.()\-]\+\s\)\+\)\s\+\([a-z0-9\.\-,]\+\)\s\+\(.\{-}\)\s\+\(.\{-}$\)]] vim.notify( vim.inspect( vim.fn.matchlist( [[Dotnet local tool manifest file               tool-manifest                           Config]], pattern)))
      end
    end
  )
end

return M
