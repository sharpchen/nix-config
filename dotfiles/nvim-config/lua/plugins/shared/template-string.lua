---@module 'lazy'
---@type LazySpec
return {
  'sharpchen/template-string.nvim',
  branch = 'csharp-fix',
  ft = {
    'cs',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'vue',
    'svelte',
    'html',
    'python',
  },
  config = function()
    require('template-string').setup {
      remove_template_string = true,
    }
  end,
}
