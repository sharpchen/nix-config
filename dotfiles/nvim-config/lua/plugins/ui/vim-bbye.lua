---@module 'lazy'
---@type LazySpec
return {
  'moll/vim-bbye',
  enabled = false, -- using snacks now
  config = function()
    local function has_dock()
      return vim.iter(vim.fn.tabpagebuflist()):any(
        function(buf)
          return vim.bo[buf].buftype == 'terminal'
          or (vim.bo[buf].filetype == 'qf' and vim.bo.filetype ~= 'qf')
        end
      )
    end

    vim.keymap.set(
      'n',
      '<A-c>',
      function() return has_dock() and ':Bdelete<CR>' or ':bd<CR>' end,
      { silent = true, expr = true }
    )

    vim.keymap.set(
      'n',
      '<A-a>',
      function() return has_dock() and ':bufdo Bdelete<CR>' or ':bufdo bd<CR>' end,
      { silent = true, expr = true }
    )
  end,
}
