return {
  'mfussenegger/nvim-dap',
  event = { 'BufReadPre' },
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
  },

  config = function()
    ---@diagnostic disable-next-line: missing-parameter
    require('nvim-dap-virtual-text').setup()
    local dap = require('dap')
    local ui = require('dapui')
    require('dapui').setup()

    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'toggle breakpoint' })
    vim.keymap.set('n', '<leader>gh', dap.run_to_cursor, { desc = 'run to cursor' })
    vim.keymap.set('n', '<leader>?', function()
      ---@diagnostic disable-next-line: missing-fields
      ui.eval(nil, { enter = true })
    end)
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'debug: continue' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'debug: step_into' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'debug: step_over' })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'debug: step_out' })
    vim.keymap.set('n', '<F6>', dap.step_back, { desc = 'debug: step_back' })
    vim.keymap.set('n', '<F9>', dap.restart, { desc = 'debug: restart' })

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'Error', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'Conditional', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'String', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'Function' })

    require('plugins.dap.netcoredbg')
    require('plugins.dap.bashdb')
    require('plugins.dap.vscode-js-debug')
  end,
}
