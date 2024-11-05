local async = require('utils').async
local M = {}

M.path = {
  vue_language_server = string.empty,
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
  async.cmd({ 'bash', '-c', 'echo -n $(readlink -f $(which vue-language-server))' }, function(result)
    local folder = vim.fs.dirname(vim.fs.dirname(result))
    M.path.vue_language_server = vim.fs.joinpath(folder, 'lib/node_modules/@vue/language-server')
  end)
end

return M
