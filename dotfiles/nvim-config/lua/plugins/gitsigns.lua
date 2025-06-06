return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPost',
  config = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Navigate to next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Navigate to prev hunk' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[S]tage current hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[R]eset current hunk' })

        map(
          'v',
          '<leader>hs',
          function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = '[S]tage selected hunk' }
        )

        map(
          'v',
          '<leader>hr',
          function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = '[R]eset current [H]unk' }
        )

        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage current file' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset current file' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[P]review current hunk' })
        map(
          'n',
          '<leader>hi',
          gitsigns.preview_hunk_inline,
          { desc = 'Preview hunk [I]nline' }
        )

        map(
          'n',
          '<leader>hb',
          function() gitsigns.blame_line { full = true } end,
          { desc = 'Show [B]lame Text' }
        )

        -- NOTE: index means the snapshot including staged changes
        map('n', '<leader>hd', gitsigns.diffthis, { desc = '[D]iff against index' })

        map(
          'n',
          '<leader>hD',
          function() gitsigns.diffthis('~') end,
          { desc = '[D]iff against last commit' }
        )

        map(
          'n',
          '<leader>hQ',
          function() gitsigns.setqflist('all') end,
          { desc = 'View repo [H]unks in [Q]flist' }
        )
        map(
          'n',
          '<leader>hq',
          gitsigns.setqflist,
          { desc = 'View file [H]unks in [Q]flist' }
        )

        -- Toggles
        map(
          'n',
          '<leader>tb',
          gitsigns.toggle_current_line_blame,
          { desc = '[T]oggle git line blame' }
        )
        map(
          'n',
          '<leader>tw',
          gitsigns.toggle_word_diff,
          { desc = '[T]oggle [W]ord diff' }
        )

        vim.keymap.set(
          { 'o', 'x' },
          'ih',
          '<Cmd>Gitsigns select_hunk<CR>',
          { desc = 'Select [H]unk' }
        )
      end,
    }
  end,
}
