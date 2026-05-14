---@module 'lazy'
---@type LazySpec
return {
  'esmuellert/codediff.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  cmd = 'CodeDiff',
  build = IsWindows and 'cmd /c build.cmd' or 'sh build.sh',
  config = function()
    require('codediff').setup {
      explorer = {
        position = 'bottom', -- "left" | "bottom"
        indent_markers = true,
        view_mode = 'tree', -- "list" | "tree"
      },
    }
    vim.api.nvim_create_autocmd('BufWinEnter', {
      callback = function(args)
        if vim.bo[args.buf].filetype == 'codediff-explorer' then
          vim.opt_local.spell = false
        end
      end,
    })
  end,
}
