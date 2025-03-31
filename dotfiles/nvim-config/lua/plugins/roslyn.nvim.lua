return {
  'seblj/roslyn.nvim',
  ft = 'cs',
  config = function()
    require('roslyn').setup({
      exe = 'Microsoft.CodeAnalysis.LanguageServer',
      ---@diagnostic disable-next-line: missing-fields
      config = {
        settings = {
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ['csharp|completion'] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ['csharp|highlighting'] = {
            dotnet_highlight_related_json_components = true,
            dotnet_highlight_related_regex_components = true,
          },
        },
      },
    })

    vim.keymap.set('n', '<leader>ni', function()
      local buf_parent = vim.fs.dirname(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
      if vim.fn.isdirectory(buf_parent) == 0 then
        vim.notify('not a valid parent')
        return
      end
      require('fzf-lua').fzf_exec(function(yield)
        for _, template in ipairs(_G.dotnet_templates) do
          yield(template.shortname)
        end
      end, {
        actions = {
          ['default'] = function(selected, _)
            require('utils.async').cmd(require('utils.env').shell.bash_cmd('dotnet new ' .. selected[1]), function(_)
              vim.notify('template ' .. selected[1] .. ' created')
            end, { cwd = buf_parent })
          end,
        },
      })
    end)
  end,
}
