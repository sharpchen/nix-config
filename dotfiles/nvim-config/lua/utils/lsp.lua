local M = {}

M.path = {
  vue_language_server = '',
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

return M
