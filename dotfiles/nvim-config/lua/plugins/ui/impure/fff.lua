---@module 'lazy'
---@type LazySpec
return {
  'dmtrKovalenko/fff.nvim',
  build = function() require('fff.download').download_or_build_binary() end,
  opts = {
    prompt_vim_mode = true,
    keymaps = {
      move_up = { '<Up>', '<C-p>', '<C-k>' },
      move_down = { '<Down>', '<C-n>', '<C-j>' },
      send_to_quickfix = '<A-q>',
    },
    debug = {
      enabled = true,
      show_scores = true,
    },
  },
  lazy = false, -- the plugin lazy-initialises itself
  keys = {
    { '<leader>ff', function() require('fff').find_files() end, desc = 'FFFind files' },
    { '<leader>fg', function() require('fff').live_grep() end, desc = 'LiFFFe grep' },
    {
      '<leader>fz',
      function() require('fff').live_grep { grep = { modes = { 'fuzzy', 'plain' } } } end,
      desc = 'Live fffuzy grep',
    },
    {
      '<leader>fc',
      function()
        local config_path = IsWindows and vim.fn.stdpath('config')
          or vim.fn.expand('~/.config/home-manager/dotfiles/nvim-config/')
        require('fff').find_files_in_dir(config_path)
      end,
      desc = 'Search current word',
    },
    {
      '<leader>fb',
      function()
        local curr_dir = vim.fs.dirname(vim.fn.bufname('%')):gsub('^oil://', '')
        require('fff').find_files_in_dir(curr_dir)
      end,
    },
    {
      '<leader>fn',
      function() require('fff').find_files_in_dir(vim.env.VIMRUNTIME) end,
    },
  },
}
