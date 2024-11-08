string.empty = ''

---@param str string
---@return boolean
function string.is_nil_or_empty(str)
  return str == nil or str == string.empty
end

---@param str string
---@return string[]
function string.to_array(str)
  local ret = {}
  for i = 1, #str do
    table.insert(ret, str:sub(i, i))
  end
  return ret
end

---@param str string
---@param target string
---@return integer
function string.indexof(str, target)
  return str:find(target:verbatim()) or -1
end

---@param str string
---@param target string
---@return integer
function string.last_indexof(str, target)
  local all = Collect(str:gmatch('()' .. target:verbatim())) --[[@as integer]]
  return all[#all] or -1
end

--- cancel escape for all character classes in lua pattern
---@param str string
---@return string
function string.verbatim(str)
  -- local c_like = { '\n', '\t', '\r', '\b', '\v', '\\' }

  local regex = ('^$()%.[]*+-?'):to_array()

  local foo = ('([%s])'):format(vim.iter(regex):fold(string.empty, function(sum, current)
    return sum .. '%' .. current
  end))

  local ret = str:gsub('%%', '%%%%'):gsub(foo, '%%%1')

  return ret
end

---split string by single char or multiple single char
---@param text string
---@param separator? string | string[]
---@return string[]
function string.split(text, separator)
  local pattern
  local set
  if separator == nil or (type(separator) == 'table' and #separator == 0) then
    pattern = '%S+'
  else
    set = type(separator) == 'table' and table.concat(separator) or separator
    pattern = ('([^%s]*)[%s]?'):format(set, set)
  end
  return vim
    .iter(Collect(text:gmatch(pattern)))
    :filter(function(x)
      return x ~= string.empty
    end)
    :totable()
end

---collect yields into array from an iterator
---@generic TResult
---@return TResult[]
---@param iterator fun(): TResult
function Collect(iterator)
  local ret = {}
  for element in iterator do
    table.insert(ret, element)
  end
  return ret
end
