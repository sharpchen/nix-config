return {
  'numToStr/Comment.nvim',
  init = function()
    vim.keymap.del({ 'n', 'x', 'o' }, 'gc')
    vim.keymap.del('n', 'gcc')
  end,
  config = function()
    require('Comment').setup()

    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    local api = require('Comment.api')

    vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { desc = 'toggle comment linewise' })

    vim.keymap.set('x', '<C-_>', function()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      api.toggle.blockwise(vim.fn.visualmode())
    end, { desc = 'toggle comment blockwise' })

    ---@return string?
    local function cursor_lang()
      local curline = vim.fn.line('.')
      local lang = vim.treesitter.get_parser():language_for_range({ curline, 0, curline, 0 }):lang()
      return lang
    end

    ---@return string | string[]
    ---@return string
    local function get_ctx()
      local lang = cursor_lang()
      assert(lang, 'lang not found')
      local cs = require('Comment.ft').get(lang)
      assert(cs, 'comment string not found')
      return cs, lang
    end

    ---@param suffix string
    ---@return function
    local function comment_eol(suffix)
      return function()
        local success, cs, lang = pcall(get_ctx)
        if not success then
          vim.notify('getting context failed', vim.log.levels.ERROR)
          return
        end
        local ori_cs = type(cs) == 'string' and cs or cs[1]
        -- vim.notify(('Current comment string: %s\nCurrent lang: %s'):format(vim.inspect(cs), lang))
        local pos = ori_cs:find('%%s')
        local sub = pos and ori_cs:sub(1, pos - 1) .. ' ' .. suffix .. ori_cs:sub(pos) or ori_cs .. suffix
        require('Comment.ft').set(lang, sub)
        require('Comment.api').insert.linewise.eol()
        vim.api.nvim_feedkeys(esc, 'x', false)
        require('Comment.ft').set(lang, cs)
      end
    end
    vim.keymap.set('n', 'gva', comment_eol('[!code ++]'), { desc = '[!code ++]' })
    vim.keymap.set('n', 'gvd', comment_eol('[!code --]'), { desc = '[!code --]' })
    vim.keymap.set('n', 'gvh', comment_eol('[!code highlight]'), { desc = '[!code highlight]' })
    vim.keymap.set('n', 'gvf', comment_eol('[!code focus]'), { desc = '[!code focus]' })
    vim.keymap.set('n', 'gvw', comment_eol('[!code warning]'), { desc = '[!code warning]' })
    vim.keymap.set('n', 'gve', comment_eol('[!code error]'), { desc = '[!code error]' })

    ---@param action fun()
    local function foreach_line(action)
      return function()
        local start_line = vim.fn.line('v')
        local end_line = vim.fn.line('.')
        vim.api.nvim_feedkeys(esc, 'x', false)
        for i = math.min(start_line, end_line), math.max(start_line, end_line) do
          vim.cmd(tostring(i))
          action()
        end
      end
    end
    vim.keymap.set('x', 'vva', foreach_line(comment_eol('[!code ++]')), { desc = '[!code ++]' })
    vim.keymap.set('x', 'vvd', foreach_line(comment_eol('[!code --]')), { desc = '[!code --]' })
    vim.keymap.set('x', 'vvh', foreach_line(comment_eol('[!code highlight]')), { desc = '[!code highlight]' })
    vim.keymap.set('x', 'vvf', foreach_line(comment_eol('[!code focus]')), { desc = '[!code focus]' })
    vim.keymap.set('x', 'vvw', foreach_line(comment_eol('[!code warning]')), { desc = '[!code warning]' })
    vim.keymap.set('x', 'vve', foreach_line(comment_eol('[!code error]')), { desc = '[!code error]' })
  end,
}
