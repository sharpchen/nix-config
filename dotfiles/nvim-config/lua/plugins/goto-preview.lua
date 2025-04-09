return {
  'rmagatti/goto-preview',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('goto-preview').setup {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    }
    vim.keymap.set(
      'n',
      'gp',
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      { desc = 'go to preview', noremap = true }
    )
  end,
}
