return {
  'lukas-reineke/indent-blankline.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  main = 'ibl',
  enabled = false,
  config = function()
    require('ibl').setup {
      indent = {
        -- char = '▏',
        char = '┊',
        smart_indent_cap = true,
        priority = 2,
        repeat_linebreak = true,
      },
      scope = {
        enabled = true,
        show_exact_scope = false,
        show_start = false,
        show_end = false,
      },
    }
  end,
}
