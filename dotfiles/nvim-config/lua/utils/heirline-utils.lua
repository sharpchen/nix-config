local M = {}
function M.auto_surround(delimiters, component)
  local child_excluded = {}
  vim
    .iter(vim.tbl_keys(component))
    :filter(function(key) return type(key) ~= 'number' end)
    :each(function(key) child_excluded[key] = component[key] end)
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

M.file = {}
function M.file.size_str(buf)
  local suffix = { 'KB', 'MB', 'GB' }
  local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
  fsize = fsize < 0 and 0 or fsize

  if fsize < 1024 then return fsize .. 'B' end

  local idx = 0
  while fsize >= 1024 and idx < #suffix do
    fsize = fsize / 1024
    idx = idx + 1
  end

  return string.format('%.2f%s', fsize, suffix[idx])
end

---@param opt { filename: string, ext: string }
function M.file.icon(opt)
  local ext = vim.fn.fnamemodify(opt.filename, ':e')
  local ft = vim.filetype.match { filename = opt.filename } or vim.bo.filetype
  local icon, icon_color = require('nvim-web-devicons').get_icon_color_by_filetype(ft)
  if not icon then
    icon, icon_color = require('nvim-web-devicons').get_icon_color_by_filetype(ext)
  end

  -- use default icon as final choice
  local default = require('nvim-web-devicons').get_default_icon()
  icon = icon or default.icon
  icon_color = icon_color or default.color

  return icon, icon_color
end

return M
