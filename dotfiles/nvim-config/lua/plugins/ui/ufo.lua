---@module 'lazy'
---@type LazySpec
return {
  'kevinhwang91/nvim-ufo',
  event = 'BufReadPost',
  dependencies = {
    'kevinhwang91/promise-async',
    {
      'luukvbaal/statuscol.nvim',
      config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          },
        }
      end,
    },
  },

  config = function()
    vim.o.foldcolumn = '1'
    vim.opt.fillchars:append([[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]])
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'unfold all levels' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'fold all levels' })
    require('ufo').setup {
      provider_selector = function(bufnr, filetype, buftype)
        if filetype == 'markdown' then return { 'treesitter', 'indent' } end
      end,
    }
  end,
}
