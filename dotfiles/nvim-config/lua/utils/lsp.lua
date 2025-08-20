local M = {
  use_vtsls = vim.fn.executable('vtsls') == 1,
}

--- wrapper for setting up and enabling language-server
---@param ls string server name
---@param config? vim.lsp.Config
function M.setup(ls, config)
  if config then vim.lsp.config[ls] = config end
  vim.lsp.enable(ls)
end

M.path = {
  vue_language_server = string.empty,
  pwsh_es = string.empty,
}

M.event = {}
---@param client vim.lsp.Client
function M.event.disable_formatter(client, _)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  client.server_capabilities.documentOnTypeFormattingProvider = nil
end
---@param client vim.lsp.Client
function M.event.disable_semantic(client)
  client.server_capabilities.semanticTokensProvider = nil
end
--- attach to navic
---@param client vim.lsp.Client
---@param bufnr integer
function M.event.attach_navic(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local ok, navic = pcall(require, 'nvim-navic')
    if ok then navic.attach(client, bufnr) end
  end
end

function M.event.default_attach(client, bufnr) M.event.attach_navic(client, bufnr) end

--- abort attachment to client on root_pattern or condition
---@param client vim.lsp.Client
---@param cond string | string[] | fun(): boolean abort when root_pattern not met or cond eval to false
function M.event.abort_on_root_not_matched(client, cond)
  local should_abort = false
  if type(cond) == 'function' then
    should_abort = cond()
  else
    local ok, lspconfig = pcall(require, 'lspconfig')
    if ok then should_abort = not lspconfig.util.root_pattern(cond)(vim.fn.getcwd()) end
  end

  if should_abort then
    vim.defer_fn(function() vim.lsp.stop_client(client.id) end, 200)
  end
end

M.config = {}
--- add filetypes for language-server
---@param ls string name of language-server
---@param extra string[] extra filetypes
---@return string[]
function M.config.ft_extend(ls, extra)
  local module = 'lspconfig.configs.' .. ls
  local ok, mo = pcall(require, module)
  local ft = {}
  if ok then
    ft = mo.default_config.filetypes
  else
    ft = vim.lsp.config[ls].filetypes
  end
  ---@cast ft table
  return vim.list_extend(extra, ft)
end
--#endregion

return M
