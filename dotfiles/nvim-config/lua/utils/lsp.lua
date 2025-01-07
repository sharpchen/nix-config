local async = require('utils.async')
local mk_store_query = require('utils.env').mk_store_query
local M = {
  use_vtsls = vim.fn.executable('vtsls') == 1,
}

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
  --- attach to navic
  ---@param client vim.lsp.Client
  ---@param bufnr integer
  attach_navic = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end
  end,

  default_attach = function(client, bufnr)
    M.event.attach_navic(client, bufnr)
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
