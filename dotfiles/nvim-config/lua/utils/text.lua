local M = {
  case = {},
}

--- replace termcode
---@param str string termcode seq
---@return string
local function translate_termcode(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

local termcode = {
  Esc = translate_termcode('<Esc>'),
  CR = translate_termcode('<CR>'),
}
M.termcode = setmetatable(termcode, {
  __call = function(_, str) return translate_termcode(str) end,
})

---@param name string
---@return boolean
M.case.is_camel = function(name)
  assert(not string.is_nil_or_empty(name))

  -- if has only single word
  if name:match('^%l+$') ~= nil then return true end

  local first = name:match('^%l+')

  if not first then return false end

  local rest = Collect(name:gmatch('%u%l+'))
  return first:len() + table.concat(rest):len() == name:len()
end

---@param name string
---@return boolean
M.case.is_snake = function(name)
  assert(not string.is_nil_or_empty(name))
  -- if has only single word
  if name:match('^%l+$') ~= nil then return true end

  local splits = name:split('_')
  return vim.iter(splits):all(function(x) return x:match('^%l+$') ~= nil end)
end

---@param name string
---@return boolean
M.case.is_pascal = function(name)
  assert(not string.is_nil_or_empty(name))
  local all = Collect(name:gmatch('%u%l+'))
  return table.concat(all):len() == name:len()
end

---@class CaseLexer
---@field next? CaseLexer
---@field chain fun(self, lexer: CaseLexer): CaseLexer
---@field handle fun(self, name: string): string[]
---@field can_handle fun(name: string): boolean
local lexer_base = {
  next = nil,
  chain = function(self, lexer)
    self.next = lexer
    return lexer
  end,
}

---@type CaseLexer
local pascal_lexer = vim.tbl_extend('error', {
  can_handle = M.case.is_pascal,
  ---@param self CaseLexer
  ---@param name string
  ---@return string[]
  handle = function(self, name)
    if not self.can_handle(name) then return self.next:handle(name) end
    assert(not string.is_nil_or_empty(name))
    return Collect(name:gmatch('%u%l*'))
  end,
}, lexer_base)

---@type CaseLexer
local camel_lexer = vim.tbl_extend('error', {
  can_handle = M.case.is_camel,
  ---@param self CaseLexer
  ---@param name string
  ---@return string[]
  handle = function(self, name)
    if not self.can_handle(name) then return self.next:handle(name) end

    if name:match('^%l+$') then return { name } end

    local first_word = name:match('^%l+')
    local rest = Collect(name:gmatch('%u%l*'))
    return vim.list_extend({ first_word }, rest)
  end,
}, lexer_base)

---@type CaseLexer
local snake_lexer = vim.tbl_extend('error', {
  can_handle = M.case.is_snake,
  ---@param self CaseLexer
  ---@param name string
  ---@return string[]
  handle = function(self, name)
    if not self.can_handle(name) then return self.next:handle(name) end

    return name:match('^%l+$') and { name } or name:split('_')
  end,
}, lexer_base)

snake_lexer:chain(camel_lexer):chain(pascal_lexer)
local case_lexer = snake_lexer

---@param word string
---@param to 'pascal' | 'camel' | 'snake'
---@return string
M.case.convert = function(word, to)
  local tokens = case_lexer:handle(word)

  if to == 'pascal' then
    return vim.iter(tokens):fold(string.empty, function(sum, current)
      sum = sum .. current:sub(1, 1):upper() .. current:sub(2)
      return sum
    end)
  elseif to == 'camel' then
    local first = tokens[1]
    local rest = {}

    for i = 2, #tokens do
      table.insert(rest, tokens[i])
    end

    return first:lower()
      .. vim.iter(rest):fold(string.empty, function(sum, current)
        sum = sum .. current:sub(1, 1):upper() .. current:sub(2)
        return sum
      end)
  elseif to == 'snake' then
    return table.concat(
      vim.iter(tokens):map(function(token) return token:lower() end):totable(),
      '_'
    )
  else
    vim.notify(string.format([[can't handle conversion from %s to %s case]], word, to))
    return word
  end
end

return M
