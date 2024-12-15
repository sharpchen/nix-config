return {
  'rebelot/heirline.nvim',
  config = function()
    local utils = require('heirline.utils')
    local const = require('utils.const')
    local conditions = require('heirline.conditions')
    local myutils = require('utils.heirline-utils')
    vim.cmd('set laststatus=3') -- share single statusline for all buffers
    vim.cmd('au VimLeavePre * set stl=')
    vim.cmd('au VimLeavePre * au! Heirline_update_autocmds')

    local sharp_delimiters = { '', '' }
    local rounded_delimiters = { '', '' }
    local delimiter = { left = rounded_delimiters[1], right = rounded_delimiters[2] }
    local function file_init(self)
      self.file_size = myutils.file_size()
      self.filename = vim.api.nvim_buf_get_name(0)
      local extension = vim.fn.fnamemodify(self.filename, ':e')
      self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(self.filename, extension, { default = true })
    end
    local function setup_colors()
      return {
        background = utils.get_highlight('Normal').bg,
        statusline = utils.get_highlight('StatusLine').bg,
        normal = utils.get_highlight('Keyword').fg,
        visual = utils.get_highlight('Function').fg,
        vline = utils.get_highlight('@type.builtin').fg,
        insert = utils.get_highlight('String').fg,
        terminal = utils.get_highlight('Type').fg,
        command = utils.get_highlight('Number').fg,
        replace = utils.get_highlight('Conditional').fg,
        diag_warn = utils.get_highlight('DiagnosticWarn').fg,
        diag_error = utils.get_highlight('DiagnosticError').fg,
        diag_hint = utils.get_highlight('DiagnosticHint').fg,
        diag_info = utils.get_highlight('DiagnosticInfo').fg,
        git_del = utils.get_highlight('DiffDelete').fg or utils.get_highlight('DiagnosticError').fg,
        git_add = utils.get_highlight('DiffAdd').fg or utils.get_highlight('String').fg,
        git_modified = utils.get_highlight('DiffChange').fg or utils.get_highlight('Keyword').fg,
        git_branch = utils.get_highlight('Conditional').fg,
      }
    end

    vim.api.nvim_create_augroup('Heirline', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
      group = 'Heirline',
    })

    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      static = {
        mode_names = {
          n = 'NORMAL',
          v = 'VISUAL',
          V = 'VLINE',
          i = 'INSERT',
          c = 'COMMAND',
          t = 'TERMINAL',
          nt = 'NORTERM',
          R = 'REPLACE',
          r = 'REPLACE',
          ['\22'] = 'VBLOCK',
          ['\22s'] = 'VBLOCK',
          s = 'SELECT',
          niI = 'NiI',
          niR = 'NiR',
          niV = 'NiV',
          ntT = 'NtT',
        },
        mode_colors = {
          n = 'normal',
          i = 'insert',
          v = 'visual',
          V = 'vline',
          c = 'command',
          t = 'terminal',
          nt = 'normal',
          R = 'replace',
          r = 'replace',
          ['\22'] = 'vline',
          s = 'visual',
          -- S = 'purple',
          -- ['\19'] = 'purple',
          ['!'] = 'normal',
          niI = 'NiI',
          niR = 'normal',
          niV = 'normal',
          ntT = 'normal',
        },
      },
      provider = function(self)
        return ' ' .. self.mode_names[self.mode]
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode], bold = true, fg = 'statusline' }
      end,
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          -- vim.notify(vim.api.nvim_get_mode().mode)
          vim.cmd('redrawstatus')
        end),
      },
    }
    local FileInfo = {
      init = file_init,
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = '  ',
        hl = { fg = 'command', bg = 'statusline' },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = '  ',
        hl = { fg = 'command', bg = 'statusline' },
      },
      { -- filename
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ':t')
          if filename == '' then
            return '[No Name]'
          end
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.fnamemodify(self.filename, ':t') -- vim.fn.pathshorten(filename)
          end
          return string.format('%s [%s]', filename, self.file_size)
        end,
      },
      hl = function(self)
        return { bg = 'statusline', fg = self.icon_color }
      end,
    }
    local FileType = {
      init = file_init,
      provider = function(self)
        return self.icon .. ' ' .. (vim.bo.filetype ~= '' and vim.bo.filetype or 'plain') .. ' '
      end,
      hl = function(self)
        return { bg = self.icon_color, fg = 'statusline' }
      end,
    }
    local FileEncoding = {
      init = file_init,
      provider = function()
        return '󰉢 ' .. vim.o.fileencoding:upper()
      end,
    }
    local System = {
      init = function(self)
        self.icon_color =
          require('nvim-web-devicons').get_icons_by_operating_system()[require('utils.static').OS_short].color
      end,
      provider = require('utils.static').OS_icon .. ' ' .. vim.bo.fileformat,
      hl = function(self)
        return { fg = self.icon_color, bg = 'statusline' }
      end,
    }
    local Diagnostic = {
      static = {
        error_icon = const.lsp.diagnostic_icons.Error,
        warn_icon = const.lsp.diagnostic_icons.Warn,
        hint_icon = const.lsp.diagnostic_icons.Hint,
        info_icon = const.lsp.diagnostic_icons.Info,
      },
      init = function(self)
        self.error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warning_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hint_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      on_click = {
        callback = function()
          vim.cmd('Telescope diagnostics')
        end,
        name = 'heirline_diagnostics',
      },
      update = { 'DiagnosticChanged', 'BufEnter' },
      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.error_count > 0 and (self.error_icon .. ' ' .. self.error_count .. ' ')
        end,
        hl = { fg = 'diag_error', bg = 'statusline' },
      },
      {
        provider = function(self)
          return self.warning_count > 0 and (self.warn_icon .. ' ' .. self.warning_count .. ' ')
        end,
        hl = { fg = 'diag_warn', bg = 'statusline' },
      },
      {
        provider = function(self)
          return self.info_count > 0 and (self.info_icon .. ' ' .. self.info_count .. ' ')
        end,
        hl = { fg = 'diag_info', bg = 'statusline' },
      },
      {
        provider = function(self)
          return self.hint_count > 0 and (self.hint_icon .. ' ' .. self.hint_count)
        end,
        hl = { fg = 'diag_hint', bg = 'statusline' },
      },
    }

    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach', 'BufEnter' },
      on_click = {
        callback = function()
          vim.defer_fn(function()
            vim.cmd('LspInfo')
          end, 100)
        end,
        name = 'heirline_LSP',
      },
      init = function(self)
        self.names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(self.names, server.name)
        end
        local filename = vim.api.nvim_buf_get_name(0)
        local extension = vim.fn.fnamemodify(filename, ':e')
        _, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return #self.names > 1 and '󰒋 [' .. table.concat(self.names, ',') .. ']' or '󰒋 ' .. self.names[1]
      end,
      hl = function(self)
        return { fg = self.icon_color, bold = true, bg = 'statusline' }
      end,
    }

    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      hl = { bg = 'statusline' },
      {
        -- git branch name
        provider = function(self)
          return '  ' .. self.status_dict.head .. ' '
        end,
        hl = { fg = 'git_branch', bold = true },
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (' ' .. count .. ' ')
        end,
        hl = { fg = 'git_add' },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (' ' .. count .. ' ')
        end,
        hl = { fg = 'git_del' },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (' ' .. count .. ' ')
        end,
        hl = { fg = 'git_modified' },
      },
      update = {
        'User',
        pattern = 'GitSignsUpdate',
        callback = vim.schedule_wrap(function()
          vim.cmd.redrawstatus()
        end),
      },
    }

    local SearchCount = {
      condition = function()
        return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
      end,
      init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
          self.search = search
        end
      end,
      provider = function(self)
        local search = self.search
        return string.format('[%d/%d]', search.current, math.min(search.total, search.maxcount))
      end,
    }

    local HelpFileName = {
      condition = function()
        return vim.bo.filetype == 'help'
      end,
      provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ':t')
      end,
      hl = { fg = 'insert' },
    }

    -- We're getting minimalist here!
    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = ' Ln %l, Col %c ',
      init = file_init,
      hl = function(self)
        return { bg = 'terminal', fg = 'statusline' }
      end,
    }

    local align = { provider = '%=' }
    local sp = { provider = ' ' }
    local DefaultStatusLine = {
      myutils.auto_surround({ nil, delimiter.right }, ViMode),
      sp,
      FileInfo,
      Git,
      sp,
      SearchCount,
      align,
      Diagnostic,
      sp,
      LSPActive,
      sp,
      FileEncoding,
      sp,
      System,
      sp,
      myutils.auto_surround({ rounded_delimiters[1], nil }, FileType),
      -- myutils.auto_surround({ delimiter.left, nil }, Ruler),
    }
    local InactiveStatusLine = {
      condition = conditions.is_not_active,
      FileType,
      sp,
      FileInfo,
      align,
    }
    local SpecialStatusline = {
      condition = function()
        return conditions.buffer_matches({
          buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
          filetype = { '^git.*', 'fugitive' },
        })
      end,
      myutils.auto_surround({ nil, delimiter.right }, ViMode),
      sp,
      HelpFileName,
      align,
      System,
      sp,
      myutils.auto_surround({ rounded_delimiters[1], nil }, FileType),
    }
    local TerminalName = {
      -- we could add a condition to check that buftype == 'terminal'
      -- or we could do that later (see #conditional-statuslines below)
      provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
        return ' ' .. tname
      end,
      hl = { fg = 'terminal', bold = true },
    }
    local TerminalStatusline = {
      condition = function()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      hl = { bg = 'statusline', fg = 'statusline' },
      -- Quickly add a condition to the ViMode to only show it when buffer is active!
      { condition = conditions.is_active, myutils.auto_surround({ nil, rounded_delimiters[2] }, ViMode), sp },
      TerminalName,
      align,
      System,
    }

    require('heirline').setup({
      update = { 'BufWritePost' },
      statusline = {
        hl = function()
          if conditions.is_active() then
            return 'StatusLine'
          else
            return 'StatusLineNC'
          end
        end,
        SpecialStatusline,
        TerminalStatusline,
        InactiveStatusLine,
        DefaultStatusLine,
        fallthrough = false,
      },
    })

    vim.api.nvim_create_user_command('Heirline', function()
      local Path = require('plenary.path')
      vim.cmd(('source %s'):format(Path:new({ vim.fn.stdpath('config'), 'after/plugin/heirline.lua' })))
    end, { desc = 'reload heirline' })
  end
}
