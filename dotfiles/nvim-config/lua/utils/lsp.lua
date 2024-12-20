local async = require('utils.async')
local mk_store_query = require('utils.env').mk_store_query
local M = {}

M.path = {
  vue_language_server = string.empty,
  pwsh_es = string.empty,
}

M.event = {
  ---@param client vim.lsp.Client
  disable_formatter = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  ---@param client vim.lsp.Client
  disable_semantic = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
}

---@return vim.lsp.Client[]
M.attached_clients = function()
  return vim.lsp.get_clients({ bufnr = 0 })
end

if not require('utils.env').is_windows then
  async.cmd(mk_store_query('vue-language-server'), function(result)
    M.path.vue_language_server = vim.fs.joinpath(result, 'lib/node_modules/@vue/language-server')
  end)
  async.cmd(mk_store_query('powershell-editor-services'), function(result)
    M.path.pwsh_es = vim.fs.joinpath(result, 'lib/powershell-editor-services')
  end)
end

return M
