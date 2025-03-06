return {
  -- 'numToStr/Comment.nvim',
  'sharpchen/Comment.nvim',
  branch = 'sum',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    },
  },
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    vim.keymap.del({ 'n', 'x', 'o' }, 'gc')
    vim.keymap.del('n', 'gcc')
  end,
  config = function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })

    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    local api = require('Comment.api')

    vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { desc = 'toggle comment linewise' })

    vim.keymap.set('x', '<C-_>', function()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      api.toggle.blockwise(vim.fn.visualmode())
    end, { desc = 'toggle comment blockwise' })

    ---@return string | string[]
    ---@return string
    local function get_ctx()
      local ft = require('utils.static').buf.cursor_ft()
      assert(ft, 'lang not found')
      local cs = require('Comment.ft').get(ft)
      assert(cs, 'comment string not found')
      return cs, ft
    end

    ---@param suffix string
    ---@return function
    local function comment_eol(suffix)
      return function()
        local ok, cs, ft = pcall(get_ctx)
        if not ok then
          vim.notify('getting context failed', vim.log.levels.ERROR)
          return
        end
        local line_cs = type(cs) == 'string' and cs or cs[1]
        local pos = line_cs:find('%%s')
        -- NOTE: this sub keeps a %s within it so it can pass the check of `Comment.U.unwrap_cstr`
        local sub = pos and line_cs:sub(1, pos - 1) .. ' ' .. suffix .. line_cs:sub(pos) or line_cs .. suffix
        require('Comment.ft').set(ft, sub)
        require('Comment.api').insert.linewise.eol()
        vim.api.nvim_feedkeys(esc, 'x', false)
        require('Comment.ft').set(ft, cs)
      end
    end

    local stay_still = require('utils.static').mark.wrap

    vim.keymap.set('n', 'gva', stay_still(comment_eol('[!code ++]')), { desc = '[!code ++]' })
    vim.keymap.set('n', 'gvd', stay_still(comment_eol('[!code --]')), { desc = '[!code --]' })
    vim.keymap.set('n', 'gvh', stay_still(comment_eol('[!code highlight]')), { desc = '[!code highlight]' })
    vim.keymap.set('n', 'gvf', stay_still(comment_eol('[!code focus]')), { desc = '[!code focus]' })
    vim.keymap.set('n', 'gvw', stay_still(comment_eol('[!code warning]')), { desc = '[!code warning]' })
    vim.keymap.set('n', 'gve', stay_still(comment_eol('[!code error]')), { desc = '[!code error]' })

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

    vim.keymap.set('x', 'vva', stay_still(foreach_line(comment_eol('[!code ++]'))), { desc = '[!code ++]' })
    vim.keymap.set('x', 'vvd', stay_still(foreach_line(comment_eol('[!code --]'))), { desc = '[!code --]' })
    vim.keymap.set(
      'x',
      'vvh',
      stay_still(foreach_line(comment_eol('[!code highlight]'))),
      { desc = '[!code highlight]' }
    )
    vim.keymap.set('x', 'vvf', stay_still(foreach_line(comment_eol('[!code focus]'))), { desc = '[!code focus]' })
    vim.keymap.set('x', 'vvw', stay_still(foreach_line(comment_eol('[!code warning]'))), { desc = '[!code warning]' })
    vim.keymap.set('x', 'vve', stay_still(foreach_line(comment_eol('[!code error]'))), { desc = '[!code error]' })

    local function remove_codehl_comment()
      local line = vim.api.nvim_get_current_line()
      if line:match('%[!code.*%]') then
        local cs, _ = get_ctx()

        cs = type(cs) == 'table' and cs[1] or cs --[[@as string]]

        if not cs then
          vim.notify('comment string not found', vim.log.levels.WARN)
          return
        end

        local cs_prefix = cs:sub(1, cs:find('%%s') - 1)
        local sub = line:sub(1, line:find('%s*' .. cs_prefix:verbatim() .. '%s*%[!code.*%]') - 1)
        vim.api.nvim_set_current_line(sub)
      end
    end

    vim.keymap.set('n', 'gvr', remove_codehl_comment, { desc = 'delete shiki highlight comment' })
  end,
}
