if HasScoop then
  vim.system({ 'scoop', 'prefix', 'git' }, { text = true }, function(out)
    if out.code == 0 then
      vim.schedule(function()
        vim.o.shell = vim.fs.joinpath(vim.trim(out.stdout), 'bin', 'bash.exe')
        vim.o.shellcmdflag = '-c'
      end)
    end
  end)
end

-- https://github.com/neovim/neovim/issues/8587#issuecomment-3557794273
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    local status = 0
    for _, f in
      ipairs(vim.fn.globpath(vim.fn.stdpath('data') .. '/shada', '*tmp*', false, true))
    do
      if vim.tbl_isempty(vim.fn.readfile(f)) then status = status + vim.fn.delete(f) end
    end
    if status ~= 0 then
      vim.notify('Could not delete empty temporary ShaDa files.', vim.log.levels.ERROR)
      vim.fn.getchar()
    end
  end,
  desc = 'Delete empty temp ShaDa files',
})
