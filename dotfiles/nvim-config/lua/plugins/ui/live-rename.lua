---@module 'lazy'
---@type LazySpec
return {
  'saecki/live-rename.nvim',
  event = 'BufReadPost',
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        vim.keymap.set(
          'n',
          'r',
          function() require('live-rename').rename() end,
          { buffer = args.buf }
        )
      end,
    })
  end,
}
