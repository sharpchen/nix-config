local M = {}
function M.auto_surround(delimiters, component)
  local child_excluded = {}
  vim
    .iter(vim.tbl_keys(component))
    :filter(function(key)
      return type(key) ~= 'number'
    end)
    :each(function(key)
      child_excluded[key] = component[key]
    end)
  return {
    vim.tbl_extend('keep', {
      provider = delimiters[1] or '',
      hl = function(self)
        local fg, bg
        if type(component.hl) == 'function' then
          fg, bg = component.hl(self).bg, component.hl(self).fg
        elseif type(component.hl) == 'table' then
          fg, bg = component.hl.bg, component.hl.fg
        end
        return { fg = fg, bg = bg }
      end,
    }, child_excluded),
    component,
    vim.tbl_extend('keep', {
      provider = delimiters[2] or '',
      hl = function(self)
        local fg, bg
        if type(component.hl) == 'function' then
          fg, bg = component.hl(self).bg, component.hl(self).fg
        elseif type(component.hl) == 'table' then
          fg, bg = component.hl.bg, component.hl.fg
        end
        return { fg = fg, bg = bg }
      end,
    }, child_excluded),
  }
end

function M.file_size()
  local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
  local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
  fsize = (fsize < 0 and 0) or fsize
  if fsize < 1024 then
    return fsize .. suffix[1]
  end
  local i = math.floor((math.log(fsize) / math.log(1024)) + 0.5)
  return string.format('%.2g%s', fsize / math.pow(1024, i), suffix[i + 1])
end

return M
