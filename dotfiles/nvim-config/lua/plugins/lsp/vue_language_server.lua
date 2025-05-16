if HasNix then
  local async = require('utils.async')
  async.cmd(require('utils.env').mk_store_query('vue-language-server'), function(result)
    require('utils.lsp').path.vue_language_server =
      vim.fs.joinpath(result, 'lib/node_modules/@vue/language-server')

    local lsp = require('utils.lsp')
    lsp.setup('volar', {
      filetypes = { 'markdown', 'vue' },
      on_attach = function(client, _)
        if vim.bo.filetype == 'markdown' then
          lsp.event.abort_on_root_not_matched(client, 'package.json')
          lsp.event.disable_formatter(client)
        end
      end,
    })
  end)
end
