---@module 'lazy'
---@type LazySpec
return {
  'rcarriga/nvim-notify',
  priority = 1000,
  config = function()
    require('notify').setup {
      timeout = 1000,
      top_down = false,
      render = 'wrapped-compact',
      merge_duplicates = false,
    }
    vim.notify = function(msg, level, opts)
      require('notify')(vim.inspect(msg), level, opts)
    end
  end,
}
