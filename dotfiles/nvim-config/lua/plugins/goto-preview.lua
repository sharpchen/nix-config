return {
  'rmagatti/goto-preview',
  event = 'BufReadPost',
  config = function()
    require('goto-preview').setup {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    }
    vim.keymap.set(
      'n',
      'gp',
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      { desc = 'go to preview',  }
    )
  end,
}
