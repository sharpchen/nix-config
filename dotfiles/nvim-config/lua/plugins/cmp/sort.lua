local cmp = require('cmp')

require('cmp').setup.global({
  ---@diagnostic disable-next-line: missing-fields
  sorting = {
    comparators = {
      cmp.config.compare.exact,
      ---prevent Text kind always on top
      function(x, y)
        local kinds = require('cmp.types.lsp').CompletionItemKind
        if x:get_kind() ~= kinds.Text and y:get_kind() == kinds.Text then
          return true
        end
        if x:get_kind() == kinds.Text and y:get_kind() ~= kinds.Text then
          return false
        end
        return cmp.config.compare.recently_used(x, y)
      end,
      ---prefer Snippet
      function(x, y)
        local kinds = require('cmp.types.lsp').CompletionItemKind
        if x:get_kind() == kinds.Snippet and y:get_kind() ~= kinds.Snippet then
          return true
        end
        if x:get_kind() ~= kinds.Snippet and y:get_kind() == kinds.Snippet then
          return false
        end
        return nil
      end,
      cmp.config.compare.length,
      cmp.config.compare.offset,
      cmp.config.compare.score,
      cmp.config.compare.kind,
    },
  },
})
