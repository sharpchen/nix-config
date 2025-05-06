return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup {}
    local np = require('nvim-autopairs')
    local rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')

    np.add_rules {
      rule('*', '*', { 'markdown' }):with_pair(cond.not_before_regex('\n')),
      -- rule('~', '*', { 'markdown' }):with_pair(cond.not_before_regex('\n')),
      -- rule('_', '_', { 'markdown' }):with_pair(cond.before_regex('%s')),
    }
  end,
}
