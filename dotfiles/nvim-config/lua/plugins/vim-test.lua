---@module 'lazy'
---@type LazySpec
return {
  'vim-test/vim-test',
  dependencies = { 'tpope/vim-dispatch' },
  keys = {
    { '<leader>tf', '<cmd>TestFile<CR>', desc = 'Tests: Run file' },
    { '<leader>ts', '<cmd>TestSuite<CR>', desc = 'Tests: Run all' },
    { '<leader>tl', '<cmd>TestLast<CR>', desc = 'Tests: Run last' },
    { '<leader>tn', '<cmd>TestNearest<CR>', desc = 'Tests: Run nearest' },
  },
  config = function()
    vim.g['test#strategy'] = 'dispatch'
    vim.g['test#csharp#runner'] = 'dotnettest'
    -- vim.g['test#csharp#dotnettest#args'] = '-p:WarningLevel=0'
    vim.g['test#strategy'] = 'custom'
    vim.g['test#custom_strategies'] = {
      custom = function(cmd)
        if pcall(require, 'snacks') then
          Snacks.terminal.open(cmd, {
            auto_close = false,
            auto_insert = false,
            win = { position = 'bottom' },
          })

          vim.cmd('stopinsert') -- Make sure we are not in insert mode
          vim.cmd('normal! G')
          vim.cmd('wincmd p') -- Go back to the previous window
        end
      end,
    }
  end,
}
