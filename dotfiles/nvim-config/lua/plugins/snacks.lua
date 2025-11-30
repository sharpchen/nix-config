---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      local function to_qf(picker)
        picker:close()
        local sel = picker:selected()
        local items = #sel > 0 and sel or picker:items()
        local qf = {} ---@type vim.quickfix.entry[]
        for _, item in ipairs(items) do
          qf[#qf + 1] = {
            filename = Snacks.picker.util.path(item),
            bufnr = item.buf,
            lnum = item.pos and item.pos[1] or 1,
            col = item.pos and item.pos[2] + 1 or 1,
            end_lnum = item.end_pos and item.end_pos[1] or nil,
            end_col = item.end_pos and item.end_pos[2] + 1 or nil,
            text = item.line
              or item.comment
              or item.label
              or item.name
              or item.detail
              or item.text,
            pattern = item.search,
            valid = true,
          }
        end
        vim.fn.setqflist(qf, 'r')
        vim.cmd('botright copen')
      end
      require('snacks').setup {
        picker = {
          enabled = true,
          ui_select = true,
          actions = { to_qf = to_qf },
          win = {
            input = {
              keys = {
                ['<M-q>'] = { 'to_qf', mode = { 'n', 'i' } },
              },
            },
          },
        },
        bigfile = { enabled = true, notify = true },
      }
      vim.api.nvim_create_user_command('GitOpen', function(e)
        ---@type snacks.gitbrowse.Config
        local opts = {
          open = function(url)
            if IsWSL then
              vim.fn.setreg('+', url)
            else
              vim.ui.open(url)
            end
          end,
        }

        if e.args then
          if e.args == 'homepage' then
            opts.what = 'repo'
          else
            opts.what = e.args:is_nil_or_empty() and 'commit' or e.args
          end
        end

        if e.line1 and e.line2 then
          opts.line_start = e.line1
          opts.line_end = e.line2
        end

        Snacks.gitbrowse.open(opts)
      end, {
        nargs = '?',
        range = true,
        complete = function() return { 'homepage', 'permalink' } end,
      })
      vim.keymap.set('n', '<leader>fc', function()
        local config_path = IsWindows and vim.fn.stdpath('config')
          or vim.fn.expand('~/.config/home-manager/dotfiles/nvim-config/')
        Snacks.picker.files { cwd = config_path }
      end, { desc = 'find nvim config file' })

      vim.keymap.set(
        'n',
        '<leader>fg',
        function() Snacks.picker.grep { hidden = true } end,
        { desc = 'grep from files' }
      )
      vim.keymap.set(
        'n',
        '<leader>ff',
        function() Snacks.picker.git_files { cwd = vim.uv.cwd() } end,
        { desc = 'find in all tracked files' }
      )
      vim.keymap.set('n', '<leader>fh', Snacks.picker.help, { desc = 'help tags' })
      vim.keymap.set(
        'n',
        '<leader>fa',
        function() Snacks.picker.files { hidden = true } end,
        { desc = 'find files' }
      )
      vim.keymap.set(
        'n',
        '<leader>fe',
        Snacks.picker.diagnostics_buffer,
        { desc = 'document diagnostics' }
      )
      vim.keymap.set(
        'n',
        '<leader>fo',
        Snacks.picker.recent,
        { desc = 'search recent files' }
      )

      vim.keymap.set('n', '<leader>fd', function()
        Snacks.picker {
          finder = 'proc',
          cmd = 'fd',
          args = { '-t=d', '-E', '.git/', '-H' },
          title = 'Directories',
          cwd = vim.uv.cwd(),
          layout = { preset = 'select' },
          transform = function(item, _)
            item.dir = true
            item.file = item.text
          end,
        }
      end, { desc = 'search folders' })

      vim.keymap.set('n', '<leader>fb', function()
        Snacks.picker {
          finder = 'proc',
          cmd = 'fd',
          args = { '-d', '1', '-a', '-H' },
          transform = function(item, _)
            if vim.fn.isdirectory(item.text) == 1 then item.dir = true end
            item.file = item.text
          end,
          cwd = vim.fs.dirname(vim.fn.bufname('%')):gsub('^oil://', ''),
        }
      end, { desc = 'find files in current folder' })

      vim.keymap.set(
        'n',
        '<leader>fr',
        function() vim.cmd(('Oil %s'):format(vim.uv.cwd())) end,
        { desc = 'root folder' }
      )

      vim.keymap.set('n', [[<leader>fl]], function()
        local lazy_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
        Snacks.picker {
          finder = 'proc',
          cmd = 'fd',
          args = { '-d', '1', '-t=d', '-E', '.git/' },
          cwd = lazy_path,
          title = 'Lazy plug',
          layout = { preset = 'select' },
          transform = function(item, _)
            item.dir = true
            item.file = item.text
          end,
          confirm = function(self, item, _)
            self:close()
            vim.fn.chdir(vim.fs.joinpath(lazy_path, item.file))
          end,
        }
      end, { desc = 'search plugin source file installed by lazy' })

      vim.keymap.set('n', [[<leader>fp]], function()
        local cwd = vim.fn.expand('~/projects/')
        Snacks.picker {
          finder = 'proc',
          cmd = 'fd',
          args = { '-d', '1', '-t=d', '-E', '.git/' },
          cwd = cwd,
          title = 'Projects',
          transform = function(item, _)
            item.dir = true
            item.file = item.text
          end,
          layout = { preset = 'select' },
          confirm = function(self, item, _)
            self:close()
            vim.fn.chdir(vim.fs.joinpath(cwd, item.file))
          end,
        }
      end, { desc = 'find projects' })
      vim.keymap.set('n', [[<leader>lg]], function() Snacks.lazygit() end)

      vim.api.nvim_create_user_command(
        'Term',
        function(args)
          Snacks.terminal.open(nil, {
            cwd = vim.fn.expand('%:p:h'):gsub('^oil:', ''),
            auto_close = false,
          })
        end,
        { desc = 'open parent of current buffer in term' }
      )
      local current_term ---@type snacks.win?
      vim.keymap.set('n', [[<M-`>]], function()
        if not current_term then
          current_term = Snacks.terminal.open(nil, {
            cwd = vim.fn.expand('%:p:h'):gsub('^oil:', ''),
            auto_close = false,
            auto_insert = false,
          })
        else
          current_term:toggle()
          if not current_term.closed then
            -- NOTE: if term is already exited
            -- close the window and spawn a new one
            if vim.bo.buftype ~= 'terminal' then
              current_term:close()
              current_term = Snacks.terminal.open(nil, {
                cwd = vim.fn.expand('%:p:h'):gsub('^oil:', ''),
                auto_close = false,
                auto_insert = false,
              })
            end
          end
        end
      end, { desc = 'Open terminal on current path' })
      vim.keymap.set(
        'n',
        [[<leader>fn]],
        function()
          Snacks.picker.files {
            cwd = vim.env.VIMRUNTIME,
            hidden = true,
          }
        end,
        { desc = 'search vim runtime files' }
      )

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'snacks_picker_input',
        callback = function(args)
          vim.keymap.set(
            'n',
            '<leader>b',
            [[mzhebi\b<Esc>ea\b<Esc>`z]],
            { buffer = args.buf }
          )
        end,
      })
    end,
  },
  {
    'rachartier/tiny-code-action.nvim',
    event = 'LspAttach',
    config = function()
      require('tiny-code-action').setup {
        picker = 'snacks',
      }
      vim.keymap.set(
        { 'n', 'x' },
        '<leader>ca',
        function() require('tiny-code-action').code_action {} end
      )
    end,
  },
}
