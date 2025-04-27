local async = require('utils.async')
local mk_store_query = require('utils.env').mk_store_query
local M = {
  use_vtsls = vim.fn.executable('vtsls') == 1,
}

--- wrapper for setting up and enabling language-server
---@param ls string server name
---@param config? vim.lsp.Config
M.setup = function(ls, config)
  if config then vim.lsp.config[ls] = config end
  vim.lsp.enable(ls)
end

M.path = {
  vue_language_server = string.empty,
  pwsh_es = string.empty,
}

M.event = {
  ---@param client vim.lsp.Client
  disable_formatter = function(client, _)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = nil
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

  default_attach = function(client, bufnr) M.event.attach_navic(client, bufnr) end,
  --- abort attachment to client on root_pattern or condition
  ---@param client vim.lsp.Client
  ---@param cond string | string[] | fun(): boolean abort when root_pattern not met or cond eval to false
  abort_on = function(client, cond)
    local should_abort = false
    if type(cond) == 'function' then
      should_abort = cond()
    else
      should_abort = not require('lspconfig').util.root_pattern(cond)(vim.fn.getcwd())
    end

    if should_abort then
      vim.defer_fn(function() vim.lsp.stop_client(client.id) end, 200)
    end
  end,
}

M.config = {
  --- add filetypes for language-server
  ---@param ls string name of language-server
  ---@param extra string[] extra filetypes
  ---@return string[]
  ft_extend = function(ls, extra)
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
  end,
}

--#region tasks to fetch language-server executables

if not require('utils.env').is_windows then
  async.cmd(
    mk_store_query('vue-language-server'),
    function(result)
      M.path.vue_language_server =
        vim.fs.joinpath(result, 'lib/node_modules/@vue/language-server')
    end
  )
  async.cmd(
    mk_store_query('powershell-editor-services'),
    function(result)
      M.path.pwsh_es = vim.fs.joinpath(result, 'lib/powershell-editor-services')
    end
  )
end

--#endregion

return M
