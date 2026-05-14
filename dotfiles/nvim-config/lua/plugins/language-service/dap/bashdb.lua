local dap = require('dap')
dap.adapters.bashdb = {
  type = 'executable',
  command = 'bashdb',
  name = 'bashdb',
}
