return {
  'mfussenegger/nvim-dap',
  event = { 'BufReadPre' },
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
  },

  config = function()
    local dap = require('dap')
    local ui = require('dapui')
    local dap_utils = require('utils.dap')
    require('dapui').setup()

    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>g', dap.run_to_cursor)
    vim.keymap.set('n', '<leader>?', function()
      ui.eval(nil, { enter = true })
    end)
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<F12>', dap.step_out)
    vim.keymap.set('n', '<F6>', dap.step_back)
    vim.keymap.set('n', '<F9>', dap.restart)

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
  end,
}
