---@module 'lazy'
---@type LazySpec
return {
  'L3MON4D3/LuaSnip',
  branch = 'master',
  dependencies = { 'rafamadriz/friendly-snippets' },
  build = 'make install_jsregexp',
  event = 'VeryLazy',
  config = function()
    require('luasnip').setup {
      update_events = { 'TextChanged', 'TextChangedI' },
      history = true,
      ext_opts = {
        [require('luasnip.util.types').choiceNode] = {
          active = {
            virt_text = { { '● oneof', 'Comment' } },
          },
        },
      },
    }

    require('luasnip').filetype_extend('axaml-cs', { 'cs' })
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').lazy_load {
      paths = { vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'luasnip') },
    }

    vim.keymap.set({ 'i', 's' }, '<C-n>', '<Plug>luasnip-next-choice')
    vim.keymap.set({ 'i', 's' }, '<C-p>', '<Plug>luasnip-prev-choice')
  end,
}
