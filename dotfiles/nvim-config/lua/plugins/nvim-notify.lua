---@module 'lazy'
---@type LazySpec
return {
  'rcarriga/nvim-notify',
  priority = 1000,
  config = function()
    require('notify').setup {
      timeout = 1000,
      top_down = true,
      render = 'wrapped-compact',
      merge_duplicates = true,
    }
    vim.notify = function(obj, level, opts)
      require('notify')(vim.inspect(obj), level, opts)
    end
  end,
}
