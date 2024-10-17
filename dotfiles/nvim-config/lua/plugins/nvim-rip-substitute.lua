return {
  'chrisgrieser/nvim-rip-substitute',
  cmd = 'RipSubstitute',
  keys = {
    {
      '\\',
      function()
        require('rip-substitute').sub()
      end,
      mode = { 'n', 'x' },
      desc = ' rip substitute',
    },
  },
  opts = {
    popupWin = {
      matchCountHlGroup = '@variable.parameter',
      noMatchHlGroup = '@variable.member',
      position = 'top',
      hideSearchReplaceLabels = true,
      border = 'rounded',
    },
  },
}
