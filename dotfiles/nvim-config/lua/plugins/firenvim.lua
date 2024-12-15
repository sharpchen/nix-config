return { 
  'glacambre/firenvim', 
  enabled = vim.uv.os_uname().sysname == 'Windows_NT',
  build = ':call firenvim#install(0)',
  config = function()
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown"
    })
  end
}
