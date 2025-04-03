return {
  'axelvc/template-string.nvim',
  ft = {
    'cs',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'vue',
    'svelte',
    'html',
  },
  -- enabled = false,
  config = function()
    require('template-string').setup({
      remove_template_string = true,
    })
  end,
}
