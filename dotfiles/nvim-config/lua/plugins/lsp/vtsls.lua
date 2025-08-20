local env = require('utils.env')
local lsp = require('utils.lsp')
local async = require('utils.async')

local inlayhint_setting = {
  parameterNames = { enabled = 'literal' },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

local function setup()
  lsp.setup('vtsls', {
    filetypes = lsp.config.ft_extend('vtsls', { 'vue', 'markdown' }),
    on_attach = function(client, bufnr)
      if vim.bo.filetype == 'markdown' then
        lsp.event.disable_formatter(client)
        vim.schedule(function() vim.lsp.stop_client(client.id) end)
      else
        lsp.event.attach_navic(client, bufnr)
      end
    end,
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        tsserver = {
          globalPlugins = {
            {
              name = '@vue/typescript-plugin',
              location = lsp.path.vue_language_server,
              languages = { 'vue', 'markdown' },
              configNamespace = 'typescript',
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
      typescript = {
        inlayHints = inlayhint_setting,
      },
      javascript = {
        inlayHints = inlayhint_setting,
      },
    },
  })
end

if HasNix then
  if lsp.path.vue_language_server:is_nil_or_empty() then
    async.cmd(env.nix_store_query('vue-language-server'), function(result)
      local vue_ls =
        vim.fs.joinpath(result, 'lib/language-tools/packages/language-server')
      if vim.fn.isdirectory(vue_ls) == 0 then
        vim.notify(vue_ls .. ' does not exist', vim.log.levels.ERROR)
      end
      lsp.path.vue_language_server = vue_ls
      setup()
    end)
  else
    setup()
  end
end
