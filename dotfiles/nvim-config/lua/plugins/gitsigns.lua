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
        end, { desc = 'navigate to next hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'navigate to prev hunk' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'stage current hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'reset current hunk' })

        map(
          'v',
          '<leader>hs',
          function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = 'stage selected hunk' }
        )

        map(
          'v',
          '<leader>hr',
          function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = 'reset selected hunk' }
        )

        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'stage current buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'reset current buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'preview hunk' })
        map(
          'n',
          '<leader>hi',
          gitsigns.preview_hunk_inline,
          { desc = 'preview hunk inline' }
        )

        map(
          'n',
          '<leader>hb',
          function() gitsigns.blame_line { full = true } end,
          { desc = 'show blame' }
        )

        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'show diff' })

        map('n', '<leader>hD', function() gitsigns.diffthis('~') end)

        map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'toggle word diff' })

        vim.keymap.set(
          { 'o', 'x' },
          'ih',
          '<Cmd>Gitsigns select_hunk<CR>',
          { desc = 'select hunk' }
        )
      end,
    }
  end,
}
