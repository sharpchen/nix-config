---@module 'lazy'
---@type LazySpec
return {
  'HiPhish/rainbow-delimiters.nvim',
  event = 'BufReadPost',
  config = function()
    ---@type rainbow_delimiters.config
    require('rainbow-delimiters.setup').setup {
      condition = function(bufnr)
        local max_filesize = 1 * 1024 * 1024 -- 1 MB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        local too_large = ok and stats and stats.size > max_filesize
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if too_large or line_count > 1000 then return false end
        return true
      end,
      blacklist = { 'html', 'xml', 'vue' },
      strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-delimiters',
      },
      priority = {
        [''] = 110,
        lua = 210,
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}
