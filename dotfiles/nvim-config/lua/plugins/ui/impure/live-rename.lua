---@module 'lazy'
---@type LazySpec
return {
  'saecki/live-rename.nvim',
  event = 'BufReadPost',
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ctx)
        local client = vim.lsp.get_client_by_id(ctx.data.client_id)

        if client and client:supports_method('textDocument/rename') then
          vim.keymap.set(
            'n',
            '<leader>r',
            function() require('live-rename').rename() end,
            { buffer = ctx.buf }
          )
        end
      end,
    })
  end,
}
