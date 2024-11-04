string.empty = ''

---@param str string
---@return boolean
function string.is_nil_or_empty(str)
  return str == nil or str == string.empty
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
